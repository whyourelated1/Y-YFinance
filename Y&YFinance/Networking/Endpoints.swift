import Foundation
struct Empty: Encodable {} //чтоб передавать «нет тела»

struct Endpoints {

    // MARK: Accounts
    static let accounts =
      AnyEndpoint<Empty, [AccountDTO]>(
          path: "/accounts",
          method: "GET",
          expect: [AccountDTO].self,
          requiresAuth: true
      )

    // MARK: Categories
    static let categories =
      AnyEndpoint<Empty, [CategoryDTO]>(
          path: "/categories",
          method: "GET",
          expect: [CategoryDTO].self,
          requiresAuth: true
      )

    // MARK: Transactions
    static func transactions(from: Date, to: Date) -> AnyEndpoint<Empty, [TransactionDTO]> {
        let iso = Formatters.isoDateOnly
        let query = "?from=\(iso.string(from: from))&to=\(iso.string(from: to))"
        return .init(
            path: "/transactions\(query)",
            method: "GET",
            expect: [TransactionDTO].self,
            requiresAuth: true
        )
    }
    
    // MARK: - Transactions MUTATIONS
    static let createTransaction =
          AnyEndpoint<TransactionCreateDTO, TransactionDTO>(
              path: "/transactions",
              method: "POST",
              expect: TransactionDTO.self,
              requiresAuth: true
          )

    static func updateTransaction(id: Int) -> AnyEndpoint<TransactionUpdateDTO, TransactionDTO> {
            .init(
                path: "/transactions/\(id)",
                method: "PUT",
                expect: TransactionDTO.self,
                requiresAuth: true
            )
        }

    static func deleteTransaction(id: Int) -> AnyEndpoint<Empty, EmptyServerResponse> {
            .init(
                path: "/transactions/\(id)",
                method: "DELETE",
                expect: EmptyServerResponse.self,
                requiresAuth: true
            )
    }
}

//Если DELETE возвращает пустое тело «{}» — делаем маркер‑структуру
struct EmptyServerResponse: Decodable {}
