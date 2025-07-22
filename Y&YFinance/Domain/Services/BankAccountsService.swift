protocol IBankAccountsService {
    func current() async throws -> AccountDTO
    func refresh() async throws -> AccountDTO
}

final class BankAccountsService: IBankAccountsService {
    private let api = NetworkClient()
    private var cache: AccountDTO?

    func current() async throws -> AccountDTO {
        if let cached = cache { return cached }
        return try await refresh()
    }

    @discardableResult
    func refresh() async throws -> AccountDTO {
        let list = try await api.request(Endpoints.accounts)
        guard let acc = list.first else {
            throw NetworkError.server(status: 500, message: "Empty accounts")
        }
        cache = acc
        return acc
    }
}

