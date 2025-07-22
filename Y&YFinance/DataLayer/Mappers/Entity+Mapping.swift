import Foundation

// MARK: AccountEntity ↔︎ BankAccount
extension AccountEntity {

    convenience init(from domain: BankAccount) {
        self.init(id:       domain.id,
                  name:     domain.name,
                  balance:  domain.balance,
                  currency: domain.currency)
    }

    func toDomain() -> BankAccount {
        BankAccount(id: id,
                    name: name,
                    balance: balance,
                    currency: currency)
    }
}

// MARK: CategoryEntity ↔︎ Category
extension CategoryEntity {

    convenience init(from domain: Category) {
        self.init(id: domain.id,
                  name: domain.name,
                  emoji: String(domain.emoji),
                  directionRaw: domain.direction.rawValue)
    }

    func toDomain() -> Category {
        Category(id: id,
                 name: name,
                 emoji: Character(emoji),
                 direction: Direction(rawValue: directionRaw) ?? .outcome)
    }
}

// MARK: TransactionEntity ↔︎ TransactionDTO
extension TransactionEntity {

    // Entity ← DTO (от сервера)
    convenience init(from dto: TransactionDTO) {
        self.init(id: dto.id,
                  accountId: dto.accountId,
                  categoryId: dto.categoryId,
                  amount: Decimal(string: dto.amount) ?? 0,
                  date: Formatters.parseISO(dto.transactionDate) ?? Date(),
                  comment: dto.comment)
    }

    func toDTO() -> TransactionDTO {
        TransactionDTO(id: id,
                       accountId: accountId,
                       categoryId: categoryId,
                       amount: "\(amount)",
                       transactionDate: Formatters.isoMillis.string(from: date),
                       comment: comment,
                       createdAt: "",
                       updatedAt: "")
    }

    // Entity ← Domain (локально созданная транзакция)
    convenience init(from domain: Transaction) {
        self.init(id: domain.id,
                  accountId: domain.account.id,
                  categoryId: domain.category.id,
                  amount: domain.amount,
                  date: domain.date,
                  comment: domain.comment)
    }

    // Entity → Domain (для UI)
    func toDomain(category: Category, account: BankAccount) -> Transaction {
        Transaction(id: id,
                    amount: amount,
                    date: date,
                    comment: comment,
                    category: category,
                    account: account)
    }
}
