protocol TransactionsStore {
    func all() async -> [TransactionDTO]
    func upsert(_ dto: TransactionDTO) async
    func delete(id: Int) async
}
