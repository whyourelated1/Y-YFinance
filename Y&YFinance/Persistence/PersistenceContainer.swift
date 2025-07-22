import SwiftData

enum PersistenceContainer {
    static let shared: ModelContainer = {
        try! ModelContainer(
            for: AccountEntity.self,
                CategoryEntity.self,
                TransactionEntity.self,
                TxBackupEntity.self
        )
    }()
}
