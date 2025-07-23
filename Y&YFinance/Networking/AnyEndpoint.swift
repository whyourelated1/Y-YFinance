struct AnyEndpoint<Request: Encodable, Response: Decodable> {
    let path: String          // "/accounts" или "/path?param=value"
    let method: String        // "GET", "POST"…
    let expect: Response.Type // просто хранится, чтобы компилятор знал
    let requiresAuth: Bool
    
    init(
        method: String,
        path: String,
        requiresAuth: Bool = true,
        expect: Response.Type
    ) {
        self.method = method
        self.path = path
        self.requiresAuth = requiresAuth
        self.expect = expect
    }
}
