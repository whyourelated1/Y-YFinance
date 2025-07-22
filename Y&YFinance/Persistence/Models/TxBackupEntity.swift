import Foundation
import SwiftData

@Model
final class TxBackupEntity {
    @Attribute(.unique) var id: String     // UUID().uuidString
    var entityId: Int
    var entityType: String      // "transaction" | "account"
    var operationType: String   // "create" | "update" | "delete"
    var payload: Data?          // JSON с телом запроса
    var timestamp: Date

    init(id: String,
         entityId: Int,
         entityType: String,
         operationType: String,
         payload: Data?,
         timestamp: Date) {
        self.id = id
        self.entityId = entityId
        self.entityType = entityType
        self.operationType = operationType
        self.payload = payload
        self.timestamp = timestamp
    }
}
