import Foundation

protocol SortsOperations: AnyObject {
    var order: TransactionsSort { get set }
    //текущий итог после сортировки
    var orderedOutput: TransactionsOutput? { get }
}

extension SortsOperations where Self: HasTxViewState {

    var orderedOutput: TransactionsOutput? {
        guard case let .success(output) = viewState else { return nil }
        let sorted = sort(output.transactions)
        return TransactionsOutput(transactions: sorted, total: output.total)
    }

    private func sort(_ list: [Transaction]) -> [Transaction] {
        switch order {
        case .date:
            return list.sorted(by: { $0.date > $1.date })
        case .amount:
            return list.sorted(by: { $0.amount > $1.amount })

        }
    }
}
