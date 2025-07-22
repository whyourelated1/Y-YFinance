import Foundation
protocol ITransactionsService {
    func list(from: Date, to: Date) async throws -> [TransactionDTO]
    func create(_ dto: TransactionCreateDTO) async throws -> TransactionDTO
    func edit(id: Int, dto: TransactionUpdateDTO) async throws -> TransactionDTO
    func delete(id: Int) async throws
}

final class TransactionsService: ITransactionsService {

    private let api = NetworkClient()
    private let accounts: IBankAccountsService

    init(accounts: IBankAccountsService = BankAccountsService()) {
        self.accounts = accounts
    }

    // GET
    func list(from: Date, to: Date) async throws -> [TransactionDTO] {
        try await api.request(Endpoints.transactions(from: from, to: to))
    }

    // POST
    func create(_ dto: TransactionCreateDTO) async throws -> TransactionDTO {
        let created = try await api.request(Endpoints.createTransaction, body: dto)
        try await accounts.refresh()         // баланс поменялся
        return created
    }

    // PUT
    func edit(id: Int, dto: TransactionUpdateDTO) async throws -> TransactionDTO {
        let updated = try await api.request(Endpoints.updateTransaction(id: id), body: dto)
        try await accounts.refresh()
        return updated
    }

    // DELETE
    func delete(id: Int) async throws {
        _ = try await api.request(Endpoints.deleteTransaction(id: id))
        try await accounts.refresh()
    }
}

