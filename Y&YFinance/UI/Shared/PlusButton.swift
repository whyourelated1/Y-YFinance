import SwiftUI

struct PlusButton: View {
    let action: () -> Void
    var icon: String = "plus"

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 30)
    }
}
