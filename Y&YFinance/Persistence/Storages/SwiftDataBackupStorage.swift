import Foundation
import SwiftData

final class SwiftDataTransactionsBackupStorage: TransactionsBackupStore {

    private let ctx: ModelContext
    init(modelContext: ModelContext) { self.ctx = modelContext }

    // MARK: - Read
    func all() async -> [TxBackupEntity] {
        (try? ctx.fetch(FetchDescriptor<TxBackupEntity>())) ?? []
    }

    // MARK: - Add / Update
    func add(id: Int, action: BackupAction, payload: Data?) async {
        if let existing = try? ctx.fetch(
            FetchDescriptor<TxBackupEntity>(predicate: #Predicate { $0.entityId == id })
        ).first {
            existing.operationType = action.rawValue
            existing.payload       = payload
            existing.timestamp     = Date()
        } else {
            ctx.insert(
                TxBackupEntity(
                    id: UUID().uuidString,
                    entityId: id,
                    entityType: "transaction",
                    operationType: action.rawValue,
                    payload: payload,
                    timestamp: Date()
                )
            )
        }
        try? ctx.save()
    }

    // MARK: - Remove
    func remove(ids: [Int]) async {
        for id in ids {
            if let model = try? ctx.fetch(
                FetchDescriptor<TxBackupEntity>(predicate: #Predicate { $0.entityId == id })
            ).first {
                ctx.delete(model)
            }
        }
        try? ctx.save()
    }
}
