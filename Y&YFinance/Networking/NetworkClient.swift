import Foundation
final class NetworkClient {
    private let session = URLSession(configuration: .default)
    private let baseURL = URL(string: "https://shmr-finance.ru")!
    enum Auth {
        static let bearer: String = "wGxyUVjMpXLknl2Av3eqhjxI"
    }
    func request<Req: Encodable, Res: Decodable>(
        _ endpoint: AnyEndpoint<Req, Res>,
        body: Req? = nil
    ) async throws -> Res {

        //URL
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if endpoint.requiresAuth {
            request.setValue("Bearer \(Auth.bearer)", forHTTPHeaderField: "Authorization")
        }

        //Encode body
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch { throw NetworkError.encodingFailed(error) }
        }

        //Perform
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.network(URLError(.badServerResponse))
            }
            guard 200..<300 ~= http.statusCode else {
                let msg = String(data: data, encoding: .utf8)
                throw NetworkError.server(status: http.statusCode, message: msg)
            }

            //Decode
            do {
                return try JSONDecoder().decode(Res.self, from: data)
            } catch { throw NetworkError.decodingFailed(error) }

        } catch let urlErr as URLError {
            throw NetworkError.network(urlErr)
        }
    }
}

