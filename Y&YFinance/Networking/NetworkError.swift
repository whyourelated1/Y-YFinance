import Foundation
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case encodingFailed(Error)
    case network(URLError)
    case server(status: Int, message: String?)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:               return "Неверный URL"
        case .encodingFailed:           return "Не удалось подготовить запрос"
        case .network(let e):           return e.localizedDescription
        case .server(_, let msg):       return msg ?? "Ошибка сервера"
        case .decodingFailed:           return "Не удалось распарсить ответ"
        }
    }
}
