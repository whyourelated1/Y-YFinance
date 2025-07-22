import Foundation

// MARK: - Account (IBankAccountsService → UsesAccountService)

protocol UsesAccountService {
    var accountService: IBankAccountsService { get }

    func currentAccount() async throws -> BankAccount
    func refreshAccount() async throws -> BankAccount
}

extension UsesAccountService {
    func currentAccount() async throws -> BankAccount {
        try await accountService.current().toDomain()
    }
    func refreshAccount() async throws -> BankAccount {
        try await accountService.refresh().toDomain()
    }
}

// MARK: - Category (ICategoriesService → UsesCategoryService)

protocol UsesCategoryService {
    var categoryService: ICategoriesService { get }

    func categories() async throws -> [Category]
    func categories(direction: Direction) async throws -> [Category]
}

extension UsesCategoryService {
    func categories() async throws -> [Category] {
        try await categoryService.all().compactMap { $0.toDomain() }
    }
    func categories(direction: Direction) async throws -> [Category] {
        try await categories().filter { $0.direction == direction }
    }
}

// MARK: - Transaction (ITransactionsService → UsesTransactionService)

protocol UsesTransactionService {
    var txService: ITransactionsService { get }

    func fetch(
        accountId: Int,
        from: Date,
        to: Date
    ) async throws -> [Transaction]

    @discardableResult
    func create(_ tx: Transaction) async throws -> Transaction

    @discardableResult
    func update(_ tx: Transaction) async throws -> Transaction

    func delete(id: Int) async throws
}

extension UsesTransactionService
where Self: UsesCategoryService & UsesAccountService {

    func fetch(accountId: Int,
               from: Date,
               to:   Date) async throws -> [Transaction] {

        //загружаем категории и аккаунт параллельно
        async let categoriesList = categoryService.all()
        async let account        = currentAccount()

        let dtoList = try await txService.list(from: from, to: to)

        //словарь [id: Category]
        let catDict = Dictionary(
            uniqueKeysWithValues: try await categoriesList.map { ($0.id, $0) }
        )
        let acc = try await account

        // DTO → Domain
        return dtoList.compactMap { dto in
            guard let cat = catDict[dto.categoryId] else { return nil }
            return dto.toDomain(category: cat, account: acc)
        }
        .filter { $0.account.id == accountId }
    }
}


