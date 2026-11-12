import SwiftUI

struct PecasView: View {
    @State private var aberturas = 0
    var body: some View {
        VStack(spacing: 40) {
            Text("Aberturas: \(aberturas)")
            HStack(spacing: 28) { PecaCorView(); PecaGiroView(); PecaCorEscalaView() }
                .padding(.vertical, 30)
            Text("Toque para mudar a cor. Segure para girar ou ampliar.")
                .font(.callout).foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Peças")
        .onAppear { aberturas += 1 }
    }
}

struct PecaCorView: View {
    @State private var cor = Color.blue
    var body: some View {
        RoundedRectangle(cornerRadius: 12).fill(cor).frame(width: 70, height: 70)
            .onTapGesture { withAnimation { cor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) } }
            .accessibilityLabel("Peça de cor")
    }
}

struct PecaGiroView: View {
    @State private var angulo = Angle.zero
    var body: some View {
        RoundedRectangle(cornerRadius: 12).fill(.orange).frame(width: 70, height: 70)
            .rotationEffect(angulo)
            .onLongPressGesture { withAnimation { angulo += .degrees(45) } }
            .accessibilityLabel("Peça de giro")
    }
}

struct PecaCorEscalaView: View {
    @State private var cor = Color.purple
    @State private var escala = 1.0
    var body: some View {
        RoundedRectangle(cornerRadius: 12).fill(cor).frame(width: 70, height: 70)
            .scaleEffect(escala)
            .onTapGesture { withAnimation { cor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) } }
            .onLongPressGesture { withAnimation { escala = escala == 1 ? 1.3 : 1 } }
            .accessibilityLabel("Peça de cor e escala")
    }
}
