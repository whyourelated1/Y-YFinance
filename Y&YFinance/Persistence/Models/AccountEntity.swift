import Foundation
import SwiftData

@Model
final class AccountEntity {
    // — хранимые свойства
    @Attribute(.unique) var id: Int
    var name:     String
    var balance:  Decimal
    var currency: String

    // — единственный designated‑init
    init(id: Int,
         name: String,
         balance: Decimal,
         currency: String) {
        self.id       = id
        self.name     = name
        self.balance  = balance
        self.currency = currency
    }
}
