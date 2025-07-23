import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    let isHistoryView: Bool
    let onTransactionChanged: (() -> Void)?

    @State private var isEditPresented = false

    init(
        transaction: Transaction,
        isHistoryView: Bool,
        onTransactionChanged: (() -> Void)? = nil
    ) {
        self.transaction = transaction
        self.isHistoryView = isHistoryView
        self.onTransactionChanged = onTransactionChanged
    }

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { isEditPresented = true }

            HStack(spacing: 12) {
                if transaction.category.direction == .outcome {
                    ZStack {
                        Circle().fill(Color.accentColor)
                        Text(transaction.category.emoji.description)
                            .font(.system(size: 12))
                    }
                    .frame(width: 22, height: 22)
                }

                VStack(alignment: .leading) {
                    Text(transaction.category.name)

                    if let comment = transaction.comment, !comment.isEmpty {
                        Text(comment)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(transaction.formattedAmount())
                    if isHistoryView {
                        Text(transaction.formattedDate())
                    }
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        /*.fullScreenCover(isPresented: $isEditPresented) {
            TransactionFormView(
                viewModel: TransactionFormViewModel(mode: .edit(transaction: transaction)),
                onDismiss: { isEditPresented = false },
                onTransactionChanged: onTransactionChanged
            )
        }*/
    }
}
