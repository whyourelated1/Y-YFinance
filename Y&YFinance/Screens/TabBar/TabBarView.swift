import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedTab: Tab

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.content                                  // сам экран
                    .tabItem {
                        VStack {
                            Image(tab.iconName)              // ← строковое имя
                                .renderingMode(.template)
                            Text(tab.label)
                        }
                    }
                    .tag(tab)
            }
        }
        // Accent‑цвет ‑ зелёный, как в Asset “AccentColor”
        .tint(Color.accentColor)
        // фон таббара
        .toolbarBackground(colorScheme == .dark ? .black : .white, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

// MARK: - содержимое вкладок
private extension Tab {
    @ViewBuilder
    var content: some View {
        switch self {
        case .outcomes:
            TransactionsListView(
                viewModel: TransactionsListViewModel(direction: .outcome)
            )

        case .incomes:
            TransactionsListView(
                viewModel: TransactionsListViewModel(direction: .income)
            )

        case .account:
            BankAccountView(
                viewModel: BankAccountViewModel()
            )

        case .categories:
            CategoriesView(
                viewModel: CategoriesViewModel()
            )

        case .settings:
            Text(label)   // здесь позже подключите настоящий Settings‑экран
        }
    }
}

#if DEBUG
#Preview {
    TabBarView(selectedTab: .constant(.outcomes))
}
#endif
