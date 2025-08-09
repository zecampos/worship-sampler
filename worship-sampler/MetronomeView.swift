import SwiftUI

// --- NOVO ESTILO CUSTOMIZADO PARA O GROUPBOX ---
// Esta struct define um "molde" para um GroupBox com fundo escuro
struct DarkGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
                .foregroundColor(.gray)
            configuration.content
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct MetronomeView: View {
    @ObservedObject var engine: MetronomeEngine
    
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
            VStack(spacing: 20) {
                Spacer() // 1. Espaçador no topo

                // --- Conteúdo Principal ---
                VStack {
                    Text("\(Int(engine.bpm))")
                        .font(.system(size: 100, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Toggle("Acentuar primeira batida", isOn: $engine.isAccentEnabled)
                        .foregroundColor(.white)
                        .frame(maxWidth: 250)
                    
                    // Definimos o GroupBox primeiro
                    let compassBox = GroupBox("Compasso") {
                        Stepper("\(engine.beatsPerMeasure) / 4", value: $engine.beatsPerMeasure, in: 2...12)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }

                    // E agora aplicamos o estilo com um if/else
                    if sizeClass == .regular {
                        compassBox
                            .groupBoxStyle(DarkGroupBoxStyle())
                    } else {
                        compassBox // No iPhone, usa o estilo padrão
                    }
                    
                    // Outros controles...
                    HStack {
                        Button(action: {
                            engine.bpm -= 1
                            if engine.isPlaying { engine.resetTimer() }
                        }) { Image(systemName: "minus.circle.fill") }
                        
                        Slider(value: $engine.bpm, in: 40...240, step: 1)
                        
                        Button(action: {
                            engine.bpm += 1
                            if engine.isPlaying { engine.resetTimer() }
                        }) { Image(systemName: "plus.circle.fill") }
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    
                    VStack {
                        Text("Pan").foregroundColor(.white)
                        Slider(value: $engine.pan, in: -1.0...1.0, step: 0.1)
                        HStack {
                            Text("L").foregroundColor(.white); Spacer(); Text("R").foregroundColor(.white)
                        }
                    }
                }
                .frame(maxWidth: sizeClass == .regular ? 480 : .infinity)
                .padding()

                Spacer() // 2. Espaçador no meio

                // --- Botão de Play na parte de baixo ---
                Button(action: {
                    if engine.isPlaying { engine.stop() } else { engine.start() }
                }) {
                    Image(systemName: engine.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(engine.isPlaying ? .red : .green)
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
        }
}
