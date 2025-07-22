import Foundation
import SwiftData

@Model
final class TransactionEntity {
    @Attribute(.unique) var id: Int

    var accountId: Int
    var categoryId: Int

    var amount: Decimal
    var date:   Date
    var comment: String?

    init(id: Int,
         accountId: Int,
         categoryId: Int,
         amount: Decimal,
         date: Date,
         comment: String?) {
        self.id = id
        self.accountId = accountId
        self.categoryId = categoryId
        self.amount = amount
        self.date = date
        self.comment = comment
    }
}
