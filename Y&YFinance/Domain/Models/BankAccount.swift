import Foundation
struct BankAccount: Identifiable, Equatable {
    let id: Int
    let name: String
    let balance: Decimal
    let currency: String
}
