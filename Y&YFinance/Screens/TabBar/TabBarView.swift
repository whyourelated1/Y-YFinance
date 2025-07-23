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
        .tint(Color.accentColor)
        // фон таббара
        .toolbarBackground(colorScheme == .dark ? .black : .white, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

// MARK: – содержимое вкладок
private extension Tab {

    @ViewBuilder
    var content: some View {
        switch self {

        case .outcomes:
            TxListView(direction: .outcome)     // список расходов

        case .incomes:
            TxListView(direction: .income)      // список доходов

        case .account:
            Text("В разработке")
        case .categories:
            Text("В разработке")
        case .settings:
            Text("В разработке")
        }
    }
}


#if DEBUG
#Preview {
    TabBarView(selectedTab: .constant(.outcomes))
}
#endif
