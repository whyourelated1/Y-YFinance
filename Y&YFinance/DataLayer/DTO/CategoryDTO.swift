struct CategoryDTO: Codable{
    let id: Int
    let name: String
    let emoji: String        //один символ, но строкой
    let isIncome: Bool
}
