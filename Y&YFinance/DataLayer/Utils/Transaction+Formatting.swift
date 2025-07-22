import Foundation

extension Transaction {
    // «1 234,56 ₽» — с учётом валюты счёта
    func formattedAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = account.currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }

    // «12 мар 2024» (или «12:45», если нужна только дата‑время)
    func formattedDate() -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}

extension Decimal {
    //форматирует число как валюту («1 234,56 ₽»)
    func formattedAmount(code: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle           = .currency
        formatter.currencyCode          = code
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.negativeFormat        = "-¤#,##0.00"

        let number = NSDecimalNumber(decimal: self)
        return formatter.string(from: number) ?? "\(self)"
    }
}


