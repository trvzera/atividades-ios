import SwiftUI

struct MixerCorView: View {
    @State private var vermelho = 0.5
    @State private var verde = 0.5
    @State private var azul = 0.5
    @State private var travado = false

    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: vermelho, green: verde, blue: azul))
                .frame(height: 180)
                .accessibilityLabel("Prévia da cor")
            ControleCorView(vermelho: $vermelho, verde: $verde, azul: $azul, travado: travado)
            Toggle("Travar sliders", isOn: $travado)
            Button("Zerar") { vermelho = 0; verde = 0; azul = 0 }
                .buttonStyle(.borderedProminent)
                .disabled(travado)
            Spacer()
        }
        .padding()
        .navigationTitle("Mixer")
    }
}

struct ControleCorView: View {
    @Binding var vermelho: Double
    @Binding var verde: Double
    @Binding var azul: Double
    let travado: Bool

    var body: some View {
        VStack {
            HStack { Text("Vermelho"); Slider(value: $vermelho, in: 0...1).tint(.red).accessibilityLabel("Vermelho") }
            HStack { Text("Verde"); Slider(value: $verde, in: 0...1).tint(.green).accessibilityLabel("Verde") }
            HStack { Text("Azul"); Slider(value: $azul, in: 0...1).tint(.blue).accessibilityLabel("Azul") }
        }
        .disabled(travado)
    }
}
