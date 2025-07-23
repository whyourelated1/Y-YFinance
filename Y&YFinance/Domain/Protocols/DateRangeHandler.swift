import Foundation

// View‑model, которой нужно две даты (от‑до)
protocol HandlesDateRange: AnyObject {
    var fromDate: Date { get set }
    var toDate:   Date { get set }

    /// вызови, когда диапазон изменился
    func reloadData() async
}

extension HandlesDateRange {
    func setFrom(_ new: Date) {
        fromDate = new.dayStart
        if fromDate > toDate { toDate = new.dayEnd }
        Task { await reloadData() }
    }
    func setTo(_ new: Date) {
        toDate = new.dayEnd
        if toDate < fromDate { fromDate = new.dayStart }
        Task { await reloadData() }
    }
}
