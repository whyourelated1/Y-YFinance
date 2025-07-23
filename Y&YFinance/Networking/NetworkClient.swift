import Foundation
final class NetworkClient {
    private let session = URLSession(configuration: .default)
    private let baseURL = URL(string: "https://shmr-finance.ru/api/v1")!
    enum Auth {
        static let bearer: String = "wGxyUVjMpXLknl2Av3eqhjxI"
    }
    func request<Req: Encodable, Res: Decodable>(
        _ endpoint: AnyEndpoint<Req, Res>,
        body: Req? = nil
    ) async throws -> Res {
        // ——— Собираем полный URL без эскейпинга '?'
        let base       = baseURL.absoluteString                          // ".../api/v1"
        let fullString = base + "/" + endpoint.path                      // ".../api/v1/transactions/…?startDate=…"
        guard let url   = URL(string: fullString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if endpoint.requiresAuth {
            request.setValue("Bearer \(Auth.bearer)", forHTTPHeaderField: "Authorization")
        }

        // ——— Логируем
        print("[REQ] \(request.httpMethod!) \(url.absoluteString)")

        // ——— Кодируем тело, если есть
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encodingFailed(error)
            }
        }

        // ——— Выполняем один запрос
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.network(URLError(.badServerResponse))
        }
        let rawBody = String(data: data, encoding: .utf8) ?? ""
        print("[RES] \(http.statusCode): \(rawBody)")

        guard 200..<300 ~= http.statusCode else {
            throw NetworkError.server(status: http.statusCode, message: rawBody)
        }

        // ——— Декодируем
        do {
            return try JSONDecoder().decode(Res.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}

