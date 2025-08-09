import SwiftUI

struct RippleButtonStyle: ButtonStyle {
    var color: Color // A cor da "gota" será a cor do pad

    func makeBody(configuration: Configuration) -> some View {
        // Usamos um GeometryReader para saber o tamanho do botão
        GeometryReader { geometry in
            ZStack {
                // O conteúdo original do botão (o texto "Kick", etc.)
                configuration.label
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // A "gota" que vai animar
                if configuration.isPressed {
                    Circle()
                        .fill(color.opacity(0.5))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        // Começa pequeno e cresce até 3x o tamanho do botão
                        .scaleEffect(2.5)
                        // Desaparece ao final da animação
                        .opacity(0)
                        // A mágica da animação de expansão
                        .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
                }
            }
        }
    }
}
