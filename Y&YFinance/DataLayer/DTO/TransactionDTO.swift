struct TransactionDTO: Codable {
    let id             : Int
    let account        : AccountDTO        // вложенный объект
    let category       : CategoryDTO       // вложенный объект
    let amount         : String
    let transactionDate: String
    let comment        : String?
    let createdAt      : String
    let updatedAt      : String
}


struct TransactionCreateDTO: Encodable {
    let accountId: Int
    let categoryId: Int
    let amount: String        //строкой, как требует API
    let transactionDate: String
    let comment: String?
}

struct TransactionUpdateDTO: Encodable {
    let amount: String
    let transactionDate: String
    let comment: String?
}
