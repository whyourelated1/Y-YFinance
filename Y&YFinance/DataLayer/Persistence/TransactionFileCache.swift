import Foundation

final class TransactionsFileCache {

    private var dtos: [TransactionDTO] = []
    private let iso = ISO8601DateFormatter()

    // MARK: Persist
    func save(to url: URL) throws {
        let data = try JSONEncoder().encode(dtos)
        try data.write(to: url, options: .atomic)
    }

    func load(from url: URL) throws {
        let data = try Data(contentsOf: url)
        dtos = try JSONDecoder().decode([TransactionDTO].self, from: data)
    }

    // MARK: Работа с Domain‑уровнем
    func domainTransactions(categories: [Category], account: BankAccount) -> [Transaction] {
        let catById = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })

        return dtos.compactMap { dto in
            guard dto.account.id == account.id,
                  let cat = catById[dto.category.id] else {
                return nil
            }
            // преобразуем DTO→Domain, теперь метод без параметров:
            return dto.toDomain()
        }
    }

    func add(_ tx: Transaction) {
        if !dtos.contains(where: { $0.id == tx.id }) {
            dtos.append(tx.toDTO())
        }
    }

    func remove(id: Int) {
        dtos.removeAll { $0.id == id }
    }
}
