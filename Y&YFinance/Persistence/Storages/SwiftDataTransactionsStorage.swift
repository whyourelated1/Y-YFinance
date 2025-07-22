import Foundation
import SwiftData

final class SwiftDataTransactionsStorage: TransactionsStore {

    private let ctx: ModelContext
    init(modelContext: ModelContext) { self.ctx = modelContext }

    // MARK: - Все транзакции
    func all() async -> [TransactionDTO] {
        (try? ctx.fetch(FetchDescriptor<TransactionEntity>()))?
            .map { $0.toDTO() } ?? []
    }

    // MARK: - Вставить или обновить
    func upsert(_ dto: TransactionDTO) async {
        if let model = try? ctx.fetch(
            FetchDescriptor<TransactionEntity>(predicate: #Predicate { $0.id == dto.id })
        ).first {
            ctx.delete(model)                         // удаляем старую
        }
        ctx.insert(TransactionEntity(from: dto))      // вставляем новую
        try? ctx.save()
    }

    // MARK: - Удалить по id
    func delete(id: Int) async {
        if let model = try? ctx.fetch(
            FetchDescriptor<TransactionEntity>(predicate: #Predicate { $0.id == id })
        ).first {
            ctx.delete(model)
            try? ctx.save()
        }
    }
}
