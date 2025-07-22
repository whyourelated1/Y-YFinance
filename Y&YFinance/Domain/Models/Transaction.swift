import Foundation
struct Transaction: Identifiable, Equatable {
    let id: Int
    let amount: Decimal
    let date: Date
    let comment: String?
    let category: Category
    let account: BankAccount
}

struct TransactionsOutput {
    let transactions: [Transaction]
    let total: Decimal

    func totalAmountFormatted() -> String {
        let code = transactions.first?.account.currency ?? ""
        return total.formattedAmount(code: code)
    }
}
