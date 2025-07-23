import Foundation

// MARK: – AccountDTO → Domain
extension AccountDTO {
    func toDomain() -> BankAccount {
        BankAccount(
            id:       id,
            name:     name,
            balance:  Decimal(string: balance) ?? .zero,
            currency: currency
        )
    }
}

// MARK: – CategoryDTO → Domain
extension CategoryDTO {
    func toDomain() -> Category {
        Category(
            id:        id,
            name:      name,
            emoji:     Character(emoji),
            direction: isIncome ? .income : .outcome
        )
    }
}

// MARK: – TransactionDTO → Domain
extension TransactionDTO {
  func toDomain() -> Transaction {
    Transaction(
      id:       id,
      amount:   Decimal(string: amount) ?? .zero,
      date:     Formatters.parseISO(transactionDate) ?? .now,
      comment:  comment,
      category: category.toDomain(),
      account:  account.toDomain()
    )
  }
}


// MARK: – Domain → Create/Update DTOs

extension Transaction {

    /// Для отправки POST /transactions
    func toCreateDTO() -> TransactionCreateDTO {
        TransactionCreateDTO(
            accountId:       account.id,
            categoryId:      category.id,
            amount:          "\(amount)",
            transactionDate: Formatters.isoMillis.string(from: date),
            comment:         comment
        )
    }

    /// Для отправки PUT /transactions/{id}
    func toUpdateDTO() -> TransactionUpdateDTO {
        TransactionUpdateDTO(
            amount:          "\(amount)",
            transactionDate: Formatters.isoMillis.string(from: date),
            comment:         comment
        )
    }

    /// Если вам нужен полный DTO (например, для кеша), соответствующий JSON от сервера
    func toDTO() -> TransactionDTO {
        TransactionDTO(
            id:              id,
            account:         account.toDTO(),
            category:        category.toDTO(),
            amount:          "\(amount)",
            transactionDate: Formatters.isoMillis.string(from: date),
            comment:         comment,
            createdAt:       "",   // сервер заполнит эти поля сам
            updatedAt:       ""
        )
    }
}

// MARK: – Domain → AccountDTO / CategoryDTO (если нужно)

extension BankAccount {
    func toDTO() -> AccountDTO {
        AccountDTO(
            id:        id,
            userId:    0,
            name:      name,
            balance:   "\(balance)",
            currency:  currency,
            createdAt: "",          // сервер проставит
            updatedAt: ""
        )
    }
}

extension Category {
    func toDTO() -> CategoryDTO {
        CategoryDTO(
            id:       id,
            name:     name,
            emoji:    String(emoji),
            isIncome: direction == .income
        )
    }
}
