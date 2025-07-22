import Foundation
enum BackupAction: String, Codable { case create, update, delete }

protocol TransactionsBackupStore {
    func all() async -> [TxBackupEntity]
    func add(id: Int, action: BackupAction, payload: Data?) async
    func remove(ids: [Int]) async
}
