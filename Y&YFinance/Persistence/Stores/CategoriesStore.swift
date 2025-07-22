protocol CategoriesStore {
    func cacheAll(_ list: [CategoryDTO]) async
    func all() async -> [CategoryDTO]
}
