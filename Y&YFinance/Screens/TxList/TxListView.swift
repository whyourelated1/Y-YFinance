import SwiftUI

struct TxListView: View {
    @StateObject private var vm: TxListVM

    init(direction: Direction) {
        _vm = StateObject(wrappedValue: TxListVM(direction: direction))
    }

    var body: some View {
        NavigationStack {
            EntityView(
                state: vm.viewState,
                title: vm.title
            ) { output in
                ZStack(alignment: .bottomTrailing) {
                    TransactionsSection(
                        output: output,
                        isHistory: false,
                        onTransactionChanged: {
                            Task { await vm.reloadData() }
                        }
                    ) { EmptyView() }

                    PlusButton { vm.openEditor() }
                }
            }
            //.toolbar { toolbar }
            /*.navigationDestination(isPresented: $vm.showHistory) {
                TxHistoryScreen(direction: vm.direction)
            }*/
            /*.fullScreenCover(isPresented: $vm.showEditor) {
                TxFormScreen(direction: vm.direction) {
                    vm.showEditor = false
                    Task { await vm.reloadData() }
                }
            }*/
        }
        .tint(.accentColor)
        .task { await vm.reloadData() }
    }

    // MARK: – Toolbar
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: vm.openHistory) {
                Image(systemName: "clock")
            }
        }
    }
}

#Preview {
    TxListView(direction: .outcome)
}
