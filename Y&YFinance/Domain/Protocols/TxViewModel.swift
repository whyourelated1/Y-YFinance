import Foundation

//вспомогательный протокол – только состояние
protocol HasTxViewState: AnyObject {
    var viewState: ViewState<TransactionsOutput> { get set }
}
/// Собирает все нужные «кусочки» для экранов Доходы / Расходы
protocol TransactionsViewModelProtocol:
            UsesTransactionService,
            UsesAccountService,
            UsesCategoryService,
            HandlesDateRange,
            SortsOperations,
            HasTxViewState { }

extension TransactionsViewModelProtocol {

    /// Загружает операции нужного направления и считает сумму
    func fetchOutput(for dir: Direction) async {
        viewState = .loading
        do {
            let acct = try await currentAccount()
            let tx   = try await fetch(accountId: acct.id,
                                       from: fromDate,
                                       to:   toDate)

            let filtered = tx.filter { $0.category.direction == dir }
            let total    = filtered.reduce(Decimal.zero) { $0 + $1.amount }

            viewState = .success(
                TransactionsOutput(transactions: filtered, total: total)
            )
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
}

//Итоговый ViewModel экранов «Доходы/Расходы»
final class TransactionsListViewModel:
    TransactionsViewModelProtocol              // ← всего один протокол
{

    // сервисы приходит через DI или создаём моки
    let accountService: IBankAccountsService
    let categoryService: ICategoriesService
    let txService:       ITransactionsService

    // состояние
    @MainActor @Published
    var viewState: ViewState<TransactionsOutput> = .idle

    // диапазон дат и сортировка
    var fromDate: Date = Date().dayStart
    var toDate:   Date = Date().dayEnd
    var order: TransactionsSort = .date

    let direction: Direction

    init(direction: Direction,
         accountService: IBankAccountsService,
         categoryService: ICategoriesService,
         txService:       ITransactionsService) {
        self.direction        = direction
        self.accountService   = accountService
        self.categoryService  = categoryService
        self.txService        = txService
    }

    @MainActor
    func load() {
        Task {
            @MainActor
            func load() {
                Task {
                    do {
                        // 1. текущий счёт
                        let account = try await currentAccount()

                        // 2. операции за выбранный диапазон
                        let txList  = try await fetch(
                            accountId: account.id,
                            from     : fromDate,
                            to       : toDate
                        )

                        // 3. фильтрация + сумма
                        let filtered = txList.filter { $0.category.direction == direction }
                        let total    = filtered.reduce(Decimal.zero) { $0 + $1.amount }

                        // 4. обновляем состояние
                        await MainActor.run {
                            viewState = .success(
                                TransactionsOutput(
                                    transactions: filtered,
                                    total       : total
                                )
                            )
                        }
                    } catch {
                        await MainActor.run {
                            viewState = .error(error.localizedDescription)
                        }
                    }
                }
            }

        }
    }
    
    func reloadData() async {
            await fetchOutput(for: direction)
        }
}




