import Foundation

// Reads SYNQT API error bodies and the 409 check; the models decode themselves (PayinModels.swift).

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
