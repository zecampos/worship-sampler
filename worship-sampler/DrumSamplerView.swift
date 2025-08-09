import SwiftUI
import UIKit

// --- NOVA VIEW PARA O BOTÃO INDIVIDUAL ---
// Extraímos o botão para sua própria struct, simplificando o corpo principal.
struct PadButtonView: View {
    let pad: Pad
    @ObservedObject var engine: SamplerEngine
    
    // Estado para controlar a animação DESTE botão específico
    @State private var isAnimating: Bool = false

    var body: some View {
        Button(action: {
            // 1. Toca o som
            engine.play(soundFileName: pad.soundFileName)
            
            // 2. Dispara a animação
            withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) {
                isAnimating = true
            }
            
            // 3. Reseta o estado da animação após um instante
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    isAnimating = false
                }
            }
        }) {
            Text(pad.name)
                .font(.title).fontWeight(.bold).foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 150)
                // O fundo agora muda de cor quando pressionado
                .background(isAnimating ? pad.color : Color.gray.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(pad.color, lineWidth: 5)
                )
                // O botão "pula" um pouco para frente quando pressionado
                .scaleEffect(isAnimating ? 1.05 : 1.0)
        }
    }
}


// --- A DRUMSAMPLERVIEW AGORA FICA MUITO MAIS LIMPA ---
struct DrumSamplerView: View {
    @ObservedObject var engine: SamplerEngine
    let pads: [Pad]

    init(engine: SamplerEngine, pads: [Pad]) {
        self.engine = engine
        self.pads = pads
    }

    var body: some View {
        VStack {
            let columns: [GridItem] = {
                  // Detecta se o dispositivo atual é um iPad
                  if UIDevice.current.userInterfaceIdiom == .pad {
                      // Se for iPad, queremos uma grade com 3 colunas
                      return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                  } else {
                      // Se for iPhone, queremos uma grade com 2 colunas
                      return [GridItem(.flexible()), GridItem(.flexible())]
                  }
              }()
            
            Text("Drum Sampler")
                .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                .padding(.top)
                .padding(.bottom, 20)

            LazyVGrid(columns: columns, spacing: 20) {
                // O ForEach agora está muito mais simples!
                ForEach(pads) { pad in
                    PadButtonView(pad: pad, engine: engine)
                }
            }
            .padding(.horizontal)

            Spacer()

            VStack {
                Text("Pan").foregroundColor(.white)
                Slider(value: $engine.pan, in: -1.0...1.0, step: 0.1).accentColor(.white)
                HStack {
                    Text("L").foregroundColor(.gray)
                    Spacer()
                    Text("R").foregroundColor(.gray)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.1, green: 0.1, blue: 0.12).ignoresSafeArea())
    }
}
