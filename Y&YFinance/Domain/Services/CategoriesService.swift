protocol ICategoriesService {
    func all() async throws -> [CategoryDTO]     // пока DTO
}

final class CategoriesService: ICategoriesService {

    private let api = NetworkClient()

    func all() async throws -> [CategoryDTO] {
        try await api.request(Endpoints.categories)
    }
}

