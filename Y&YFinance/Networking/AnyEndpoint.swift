struct AnyEndpoint<Request: Encodable, Response: Decodable> {
    let path: String          // "/accounts"
    let method: String        // "GET", "POST"…
    let expect: Response.Type // просто хранится, чтобы компилятор знал
    let requiresAuth: Bool
}
