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

// MARK: - Transaction (ITransactionsService → UsesTransactionService)

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

    func fetch(
        accountId: Int,
        from: Date,
        to: Date
    ) async throws -> [Transaction] {
        // параллельно грузим DTO категорий и аккаунт
        async let rawCats  = categoryService.all()
        async let acctDTO  = currentAccount()

        // получаем массив DTO транзакций
        let dtoList = try await txService.list(accountId: accountId, from: from, to: to)
        
        // строим словарь id → Domain.Category
        let cats = try await rawCats
        let catDict = Dictionary(uniqueKeysWithValues: cats.map { ($0.id, $0.toDomain()) })

        let acct = try await acctDTO

        // превращаем DTO → Domain.Transaction
        return dtoList.compactMap { dto in
            // dto.category.id вместо dto.categoryId
            guard let categoryDomain = catDict[dto.category.id] else {
                return nil
            }
            // dto.toDomain() умеет читать вложенные account и category
            var tx = dto.toDomain()
            // но убедимся, что он взял правильные вложенные
            // (обычно dto.toDomain() уже создаёт Transaction(category: dto.category.toDomain(), account: dto.account.toDomain()))
            return tx
        }
    }

    @discardableResult
    func create(_ tx: Transaction) async throws -> Transaction {
        let dto = try await txService.create(tx.toCreateDTO())
        // тут dto уже содержит вложенные account и category
        return dto.toDomain()
    }

    @discardableResult
    func update(_ tx: Transaction) async throws -> Transaction {
        let dto = try await txService.edit(id: tx.id, dto: tx.toUpdateDTO())
        return dto.toDomain()
    }

    func delete(id: Int) async throws {
        try await txService.delete(id: id)
    }
}
