import SwiftUI

struct SeloView: View {
    @State private var cor = Color.blue
    @State private var escala = 1.0
    var body: some View {
        RoundedRectangle(cornerRadius: 20).fill(cor).frame(width: 120, height: 120)
            .scaleEffect(escala)
            .onTapGesture {
                withAnimation { cor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) }
            }
            .onLongPressGesture { withAnimation { escala = escala == 1 ? 1.3 : 1 } }
            .accessibilityLabel("Selo da turma")
    }
}
