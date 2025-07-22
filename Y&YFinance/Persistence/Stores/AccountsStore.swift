protocol AccountsStore {
    func save(_ dto: AccountDTO) async
    func current() async -> AccountDTO?
}
