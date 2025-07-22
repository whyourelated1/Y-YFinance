import SwiftUI
enum Tab: CaseIterable, Hashable {
    case outcomes
    case incomes
    case account
    case categories
    case settings

    // MARK: - UI helpers
    var label: String {
        switch self {
        case .outcomes:   return "Расходы"
        case .incomes:    return "Доходы"
        case .account:    return "Счёт"
        case .categories: return "Статьи"
        case .settings:   return "Настройки"
        }
    }

    var iconName: String {
        switch self {
        case .outcomes:   return "TabDown"
        case .incomes:    return "TabUp"
        case .account:    return "TabCalc"
        case .categories: return "TabStat"
        case .settings:   return "TabSetting"
        }
    }
}

