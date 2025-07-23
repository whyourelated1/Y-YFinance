import Foundation
struct Empty: Encodable {} //чтоб передавать «нет тела»

struct Endpoints {

    // MARK: Accounts
    static let accounts =
      AnyEndpoint<Empty, [AccountDTO]>(
        method: "GET", path: "accounts",
        requiresAuth: true, expect: [AccountDTO].self
      )

    // MARK: Categories
    static let categories =
      AnyEndpoint<Empty, [CategoryDTO]>(
        method: "GET", path: "categories",
        requiresAuth: true, expect: [CategoryDTO].self
      )

    // MARK: Transactions list
    static func transactions(
        accountId: Int,
        startDate: Date,
        endDate: Date
    ) -> AnyEndpoint<Empty, [TransactionDTO]> {
        let iso = Formatters.isoDateOnly
        let startDateEncoded = iso.string(from: startDate).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endDateEncoded = iso.string(from: endDate).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return .init(
            method: "GET", path: "transactions/account/\(accountId)/period?startDate=\(startDateEncoded)&endDate=\(endDateEncoded)",
            requiresAuth: true, expect: [TransactionDTO].self
        )
    }

    // MARK: - Transactions MUTATIONS
    static let createTransaction =
          AnyEndpoint<TransactionCreateDTO, TransactionDTO>(
            method: "POST", path: "transactions",
            requiresAuth: true, expect: TransactionDTO.self
          )

    static func updateTransaction(id: Int) -> AnyEndpoint<TransactionUpdateDTO, TransactionDTO> {
            .init(
                method: "PUT", path: "transactions/\(id)",
                requiresAuth: true, expect: TransactionDTO.self
            )
        }

    static func deleteTransaction(id: Int) -> AnyEndpoint<Empty, EmptyServerResponse> {
            .init(
                method: "DELETE", path: "transactions/\(id)",
                requiresAuth: true, expect: EmptyServerResponse.self
            )
    }
}

//Если DELETE возвращает пустое тело «{}» — делаем маркер‑структуру
struct EmptyServerResponse: Decodable {}
