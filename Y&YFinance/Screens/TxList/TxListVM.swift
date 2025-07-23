import Foundation
import Combine

// View‑model списка «Доходы / Расходы»
@MainActor
final class TxListVM: ObservableObject, TransactionsViewModelProtocol {

    // MARK: – Сервисы
    let accountService : IBankAccountsService
    let categoryService: ICategoriesService
    let txService      : ITransactionsService

    // MARK: – Состояние
    @Published var viewState: ViewState<TransactionsOutput> = .idle

    // MARK: – Фильтры
    var fromDate: Date = Date().dayStart
    var toDate  : Date = Date().dayEnd
    var order   : TransactionsSort = .date
    let direction: Direction

    // MARK: – Навигация
    @Published var showHistory = false
    @Published var showEditor  = false

    // MARK: – Init
    init(direction: Direction,
         accountService : IBankAccountsService = BankAccountsService(),
         categoryService: ICategoriesService  = CategoriesService(),
         txService      : ITransactionsService = TransactionsService())
    {
        self.direction        = direction
        self.accountService   = accountService
        self.categoryService  = categoryService
        self.txService        = txService
    }

    // MARK: – HandlesDateRange
    func reloadData() async { await fetchOutput(for: direction) }

    // MARK: – Публичные хелперы для View
    var title: String {
        (direction == .income ? Tab.incomes.label : Tab.outcomes.label) + " сегодня"
    }
    func openHistory() { showHistory = true }
    func openEditor () { showEditor  = true }
}
