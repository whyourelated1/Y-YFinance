import Foundation

extension AccountDTO {
    func toDomain() -> BankAccount {
        BankAccount(
            id: id,
            name: name,
            balance: Decimal(string: balance) ?? .zero,
            currency: currency
        )
    }
}

extension CategoryDTO {
    func toDomain() -> Category {
        Category(
            id: id,
            name: name,
            emoji: Character(emoji),
            direction: isIncome ? .income : .outcome
        )
    }
}
extension TransactionDTO {
    func toDomain(category: Category, account: BankAccount) -> Transaction {
        Transaction(
            id: id,
            amount: Decimal(string: amount) ?? .zero,
            date: Formatters.parseISO(transactionDate) ?? .now,
            comment: comment,
            category: category,
            account: account
        )
    }
}



// Обратный маппинг
extension Transaction {
    func toCreateDTO() -> TransactionCreateDTO {
        TransactionCreateDTO(
            accountId: account.id,
            categoryId: category.id,
            amount: "\(amount)",
            transactionDate: Formatters.isoMillis.string(from: date),
            comment: comment
        )
    }

    func toUpdateDTO() -> TransactionUpdateDTO {
        TransactionUpdateDTO(
            amount: "\(amount)",
            transactionDate: Formatters.isoMillis.string(from: date),
            comment: comment
        )
    }
    func toDTO() -> TransactionDTO {
        TransactionDTO(id: id,
                        accountId: account.id,
                        categoryId: category.id,
                        amount: "\(amount)",
                        transactionDate: Formatters.isoMillis.string(from: date),
                        comment: comment,
                        createdAt: "",   // заполняет сервер
                        updatedAt: "")
        }
}

extension BankAccount {
    func toDTO() -> AccountDTO {
        AccountDTO(
            id: id,
            userId: 0,
            name: name,
            balance: "\(balance)",
            currency: currency,
            createdAt: "", updatedAt: ""
        )
    }
}

extension Category {
    func toDTO() -> CategoryDTO {
        CategoryDTO(id: id,
                    name: name,
                    emoji: String(emoji),
                    isIncome: direction == .income)
    }
}

