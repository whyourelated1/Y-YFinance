import Foundation
import SwiftData

final class SwiftDataCategoriesStorage: CategoriesStore {

    private let ctx: ModelContext
    init(modelContext: ModelContext) { self.ctx = modelContext }

    // MARK: - Cache whole list
    func cacheAll(_ list: [CategoryDTO]) async {
        // стратегия «очистить‑и‑вставить»
        if let existing = try? ctx.fetch(FetchDescriptor<CategoryEntity>()) {
            existing.forEach { ctx.delete($0) }
        }
        list.compactMap { $0.toDomain() }
            .forEach { ctx.insert(CategoryEntity(from: $0)) }
        try? ctx.save()
    }

    // MARK: - Get all
    func all() async -> [CategoryDTO] {
        (try? ctx.fetch(FetchDescriptor<CategoryEntity>()))?
            .compactMap { $0.toDomain().toDTO() } ?? []
    }
}
