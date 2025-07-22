struct AccountDTO: Codable{
    let id: Int
    let userId: Int
    let name: String
    let balance: String      // ←строкой!
    let currency: String
    let createdAt: String
    let updatedAt: String
}
