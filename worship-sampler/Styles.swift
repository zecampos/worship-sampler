import SwiftUI

// Estilo customizado para o GroupBox com fundo escuro
struct DarkGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
                .foregroundColor(.gray)
            configuration.content
        }
        .padding()
        .background(Color.black.opacity(0.5)) // Fundo preto com um pouco de transparência
        .cornerRadius(10)
    }
}
