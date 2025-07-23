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

// MARK: - TransactionEntity ↔︎ TransactionDTO
extension TransactionEntity {
    
    // Entity ← DTO (от сервера)
    convenience init(from dto: TransactionDTO) {
        self.init(
            id:         dto.id,
            accountId:  dto.account.id,
            categoryId: dto.category.id,
            amount:     Decimal(string: dto.amount) ?? .zero,
            date:       Formatters.parseISO(dto.transactionDate) ?? Date(),
            comment:    dto.comment
        )
    }

    // Entity → DTO (для сохранения/бэкапа)
    func toDTO() -> TransactionDTO {
        // собираем вложенные DTO по собственным полям
        let accountDTO = AccountDTO(
            id:        accountId,
            userId:    0,                 // если не важно, иначе подставьте своё
            name:      "",                // у вас здесь нет имени, можно оставить пустым
            balance:   "0",               // или строка balance, если есть
            currency:  "",                // или currency, если Entity хранит
            createdAt: "", updatedAt: ""
        )
        let categoryDTO = CategoryDTO(
            id:       categoryId,
            name:     "",                 // аналогично, подставьте своё поле, если есть
            emoji:    "",                 // или String(emoji)
            isIncome: false               // или Direction(rawValue: directionRaw) == .income
        )
        
        return TransactionDTO(
            id:              id,
            account:         accountDTO,
            category:        categoryDTO,
            amount:          "\(amount)",
            transactionDate: Formatters.isoMillis.string(from: date),
            comment:         comment,
            createdAt:       "", updatedAt: ""
        )
    }
}
