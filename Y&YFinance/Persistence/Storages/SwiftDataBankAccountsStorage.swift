import Foundation
import SwiftData

final class SwiftDataAccountsStorage: AccountsStore {

    private let ctx: ModelContext
    init(modelContext: ModelContext) { self.ctx = modelContext }

    // MARK: Save
    func save(_ dto: AccountDTO) async {
        //пробуем найти существующую запись
        if let model = try? ctx.fetch(
            FetchDescriptor<AccountEntity>(predicate: #Predicate { $0.id == dto.id })
        ).first {
            //бновляем поля
            model.name     = dto.name
            model.balance  = Decimal(string: dto.balance) ?? model.balance
            model.currency = dto.currency
        } else {
            //такой записи нет, создаём новую
            ctx.insert(AccountEntity(from: dto.toDomain()))
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
