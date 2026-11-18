import Foundation

// Reads SYNQT API responses into the public models.

/// SYNQT error bodies, as a list or a single object. attrValue is dropped on purpose.
func parseErrors(_ body: Data) -> [SynqtAPIError.Reason] {
    guard let json = try? JSON.parse(body) else { return [] }
    let items: [JSON]
    if case .array = json { items = json.objects } else { items = [json] }
    return items.compactMap { item in
        item["code"]?.text.map { SynqtAPIError.Reason(code: $0, field: item["attrCode"]?.text, description: item["description"]?.text) }
    }
}

/// After a 409, the payin `existing` must be the same payment being retried, not an earlier attempt with another method.
func requireSameMethod(_ existing: Data, _ requested: String) throws {
    guard let used = (try? JSON.parse(existing))?["paymentMethodResponse"]?["paymentMethodCode"]?.text, used != requested else { return }
    // The description is for developers; the sheet shows its own translatable message for this code.
    throw SynqtAPIError(httpCode: 409, errors: [.init(code: "PAYIN_ALREADY_STARTED", field: nil,
        description: "This payin was already started with \(used). Start a new payin to pay another way.")])
}

func parseCreatePayin(_ data: Data) throws -> CreatePayinResult {
    let response = try JSON.parse(data)
    if let redirectTo = response["redirectTo"], let url = redirectTo["url"]?.text {
        let form = redirectTo["data"]?.text.flatMap { try? JSON.parse(Data($0.utf8)) }
        return .redirect(httpMethod: redirectTo["method"]?.text ?? "GET", url: url, formData: form?.fields.mapValues { $0.text ?? "" } ?? [:])
    }
    let methodResponse = response["paymentMethodResponse"] ?? .object([:])
    let method = parseMethodResponse(methodResponse)
    // A card's 3-D Secure page (CARD comes from the card add-on); FORM, CONTENT and OTP_REQUIRED stay in instructions for the app to show.
    if case .card(let card) = method, case .redirect(let redirect)? = card.userInteraction, let url = redirect.url {
        return .redirect(httpMethod: "GET", url: url, formData: [:])
    }
    return .instructions(paymentMethod: method, nextStep: parseNextStep(methodResponse))
}

/// A response that does not fit its method's model (a field of an unexpected type) still reads as `.unknown`, so a
/// payin SYNQT has created never surfaces as an error.
func parseMethodResponse(_ response: JSON) -> PaymentMethodResponse {
    response.decode(PaymentMethodResponse.self) ?? .unknown(paymentMethodCode: response["paymentMethodCode"]?.text ?? "")
}

// Every deep link field in the spec; a method returns at most one.
private let appLinkFields = ["deepLink", "zapperQrDeepLink", "snapscanQrDeepLink", "upiQrDeepLink", "payMeDeepLink"]

func parseNextStep(_ response: JSON) -> NextStep {
    NextStep(
        appLink: appLinkFields.lazy.compactMap { response[$0]?.text }.first,
        qrCodeImageURL: response["qrCode"]?.text,
        qrCodeData: response["qrRawData"]?.text,
        amountToPay: parseMoney(response["moneyRequired"]),
        reference: response["reference"]?.text,
        expiresAt: response["expireAt"]?.text,
        // shortcut: OFFLINE only, as some methods' `account` is the payer's own; add others (such as VAPAY) once checked.
        payInto: response["paymentMethodCode"]?.text == "OFFLINE" ? response["account"]?.decode(PaymentMethodResponse.Account.self) : nil
    )
}

func parsePayinStatus(_ response: JSON) -> PayinStatus {
    let process = response["process"] ?? .null
    let failure = process["failureReasons"]
    return PayinStatus(
        status: process["status"]?.text.flatMap(PayinStatus.Status.init(rawValue:)) ?? .unknown,
        requested: parseMoney(response["paymentRequested"]?["money"]) ?? Money(amount: 0, currencyCode: ""),
        fee: parseMoney(response["fee"]),
        isTest: process["isTest"]?.bool ?? false,
        failureReason: failure?["failureReasonCode"]?.text.map { FailureReason(code: $0, message: failure?["message"]?.text, failedAt: failure?["failedAt"]?.text) },
        paymentMethod: response["paymentMethodResponse"].map(parseMethodResponse),
        createdAt: process["createdAt"]?.text,
        processedAt: process["processedAt"]?.text
    )
}

func parsePaymentOptions(_ response: JSON) -> [PaymentOption] {
    (response["data"]?.objects ?? []).compactMap { option in
        option["paymentMethodCode"]?.text.map { PaymentOption(code: $0, operators: parseOperators(option["paymentOperators"]), segmentCode: option["segmentCode"]?.text) }
    }
}

/// Operators from availablePaymentOptions or GET /payment-operators; entries without a code are skipped, a missing name shows the code.
func parseOperators(_ operators: JSON?) -> [PaymentOperator] {
    (operators?.objects ?? []).compactMap { op in
        guard let code = op["code"]?.text else { return nil }
        let providers = (op["externalProviders"]?["providers"]?.objects ?? []).compactMap { provider in
            provider["code"]?.text.map { ExternalProvider(code: $0, name: provider["name"]?.text ?? $0) }
        }
        return PaymentOperator(code: code, name: op["name"]?.text ?? code, externalProviders: providers)
    }
}

private func parseMoney(_ money: JSON?) -> Money? {
    guard let amount = money?["amount"]?.text.flatMap({ Decimal(string: $0, locale: Locale(identifier: "en_US_POSIX")) }) else { return nil }
    return Money(amount: amount, currencyCode: money?["currencyCode"]?.text ?? "")
}
