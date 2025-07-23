

import XCTest
@testable import Y_YFinance

final class NetworkingLiveTests: XCTestCase {

    let api = NetworkClient()

    func testAccountsEndpoint() async throws {
        let list: [AccountDTO] = try await api.request(Endpoints.accounts)
        XCTAssertFalse(list.isEmpty, "Список счетов пустой")
    }

    func testCategoriesEndpoint() async throws {
        let list: [CategoryDTO] = try await api.request(Endpoints.categories)
        XCTAssertFalse(list.isEmpty)
    }

    func testTransactionsEndpoint() async throws {
        let now = Date()
        let week = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let list: [TransactionDTO] = try await api.request(
            Endpoints.transactions(accountId: 1, startDate: week, endDate: now)
        )
        // просто проверим, что код не свалился
        XCTAssertNotNil(list)
    }
}
