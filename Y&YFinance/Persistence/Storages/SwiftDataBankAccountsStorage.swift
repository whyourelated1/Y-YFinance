import Foundation
import SwiftData

final class SwiftDataAccountsStorage: AccountsStore {

    private let ctx: ModelContext
    init(modelContext: ModelContext) { self.ctx = modelContext }

    // MARK: - Save
    func save(_ dto: AccountDTO) async {
        if let model = try? ctx.fetch(
            FetchDescriptor<AccountEntity>(predicate: #Predicate { $0.id == dto.id })
        ).first {
            // обновляем существующий
            model.name     = dto.name
            model.balance  = Decimal(string: dto.balance) ?? model.balance
            model.currency = dto.currency
        } else if let domain = dto.toDomain() {
            // добавляем новый
            ctx.insert(AccountEntity(from: domain))
        }
        try? ctx.save()
    }

    // MARK: - Current
    func current() async -> AccountDTO? {
        guard
            let entity = try? ctx.fetch(FetchDescriptor<AccountEntity>()).first
        else { return nil }

        return entity.toDomain().toDTO()
    }

}
