import XCTest
@testable import SynqtSDK

/// Answers every request with the next status in `statuses` (the last one repeats) and counts the requests.
private final class StubSYNQT: URLProtocol {
    nonisolated(unsafe) static var statuses: [Int] = []
    nonisolated(unsafe) static var requests = 0

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let status = Self.statuses[min(Self.requests, Self.statuses.count - 1)]
        Self.requests += 1
        let body = status == 200
            ? #"{"data":[{"paymentMethodCode":"OFFLINE","paymentOperators":[{"code":"ABSA","name":"Absa"}]}]}"#
            : #"{"errors":[]}"#
        client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(body.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

final class BankListRetryTests: XCTestCase {
    private func operators(_ statuses: [Int]) async throws -> [PaymentOperator]? {
        StubSYNQT.statuses = statuses
        StubSYNQT.requests = 0
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubSYNQT.self]
        let payin = try Synqt(.sandbox, session: URLSession(configuration: config))
            .payin(token: "t", payinID: "order-1", money: Money(amount: 100, currencyCode: "ZAR"), returnURL: "https://x.io/r", callbackURL: "https://x.io/c")
        let form = try XCTUnwrap(methodForms.first { $0.code == "OFFLINE" })
        return await payin.sheetOperators(for: form, retryAfter: 1_000_000)
    }

    func testServerErrorsAreRetriedTwiceThenTheListLoads() async throws {
        let loaded = try await operators([503, 500, 200])
        XCTAssertEqual(loaded?.map(\.code), ["ABSA"])
        XCTAssertEqual(StubSYNQT.requests, 3)
    }

    func testThreeFailuresMeanTheListCouldNotBeLoaded() async throws {
        let loaded = try await operators([503])
        XCTAssertNil(loaded)
        XCTAssertEqual(StubSYNQT.requests, 3)
    }

    func testARefusalIsNotRetried() async throws {
        let loaded = try await operators([403])
        XCTAssertNil(loaded)
        XCTAssertEqual(StubSYNQT.requests, 1)
    }

    @MainActor
    func testMandatoryBankFieldWaitsForTryAgain() async throws {
        let form = try XCTUnwrap(methodForms.first { $0.code == "OFFLINE" })
        let model = PaymentSheetModel(form: form, prefill: [:], operators: nil,
                                      summary: PaymentSummary(amount: "R1.00", merchant: nil, method: "Pay offline", reference: "o-1")) { _ in throw URLError(.notConnectedToInternet) }
        let bank = try XCTUnwrap(model.inputs.first { $0.kind == .operator })
        XCTAssertTrue(model.banksMissing(bank))
        model.reloadOperators = { [PaymentOperator(code: "ABSA", name: "Absa", externalProviders: [])] }
        model.retryBanks()
        for _ in 0..<50 where model.banksFailed { try await Task.sleep(nanoseconds: 10_000_000) }
        XCTAssertFalse(model.banksMissing(bank))
        XCTAssertEqual(model.options(bank)?.contains { $0.value == "ABSA" }, true)
    }
}
