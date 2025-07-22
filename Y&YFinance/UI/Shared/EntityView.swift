import SwiftUI
enum ViewState<Success> {
    case idle                   // ещё не начинали
    case loading                // в процессе запроса
    case success(Success)       // данные получены
    case error(String)          // произошла ошибка
}

extension ViewState: Equatable where Success: Equatable {}

struct EntityView<Content, Output>: View where Content: View {
    let state: ViewState<Output>
    let title: String
    let loadingText: String
    let errorPrefix: String
    let content: (Output) -> Content

    init(
        state: ViewState<Output>,
        title: String,
        loadingText: String = Spec.loadingText,
        errorPrefix: String = Spec.errorPrefix,
        content: @escaping (Output) -> Content
    ) {
        self.state = state
        self.title = title
        self.loadingText = loadingText
        self.errorPrefix = errorPrefix
        self.content = content
    }

    var body: some View {
        VStack {
            switch state {
            case .idle, .loading:
                ProgressView(loadingText)
                    .frame(maxWidth: .infinity, alignment: .center)
            case let .error(message):
                Text(errorPrefix + message)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            case let .success(output):
                content(output)
            }
        }
        .navigationTitle(title)
    }
}

private enum Spec {
    static let loadingText = "Загружаемся..."
    static let errorPrefix = "Ошибка: "
}
