import Foundation

//коллекция переиспользуемых форматтеров + хелперов для дат.
enum Formatters {

    // MARK: - ISO‑8601

    // 1) 2024-03-01T12:34:56Z
    static let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate,
                           .withColonSeparatorInTime, .withTimeZone]
        return f
    }()

    // 2) 2024-03-01T12:34:56.789Z  (доли секунды)
    static let isoMillis: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate,
                           .withColonSeparatorInTime, .withFractionalSeconds,
                           .withTimeZone]
        return f
    }()

    // 3) 2024-03-01   (только дата, без времени)
    static let isoDateOnly: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .iso8601)
        f.locale   = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    // MARK: - Гибкий парсер

    // Пробует разобрать строку несколькими форматтерами подряд.
    static func parseISO(_ string: String) -> Date? {
        if let d = isoMillis.date(from: string) { return d }
        if let d = iso.date(from: string)       { return d }
        if let d = isoDateOnly.date(from: string) { return d }
        return nil
    }

    // MARK: - JSONDecoder / JSONEncoder c поддержкой миллисекунд

    // JSONDecoder, который сначала пытается .isoMillis, потом .iso
    static let jsonDecoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            if let d = Formatters.parseISO(str) {
                return d
            }
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Unsupported date format: \(str)")
        }
        return dec
    }()

    // JSONEncoder — по умолчанию используем миллисекунды (если сервер их понимает)
    static let jsonEncoder: JSONEncoder = {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let str = isoMillis.string(from: date)
            try container.encode(str)
        }
        enc.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        return enc
    }()
}
