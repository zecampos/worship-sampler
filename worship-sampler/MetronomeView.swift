import SwiftUI

struct MetronomeView: View {
    // @StateObject cria e gerencia uma instância do nosso motor
    @ObservedObject var engine: MetronomeEngine
    var body: some View {
        VStack {
            // Display do BPM
            Text("\(Int(engine.bpm))")
                .font(.system(size: 80, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            HStack {
                // Botão de diminuir BPM
                Button(action: {
                    engine.bpm -= 1
                    if engine.isPlaying {
                        engine.resetTimer()
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 30)
                
                // Slider de BPM (mais discreto)
                Slider(value: $engine.bpm, in: 40...240, step: 1)
                    .accentColor(.accentColor) // Mantém a cor definida no Assets
                    .frame(maxWidth: 200)
                
                // Botão de aumentar BPM
                Button(action: {
                    engine.bpm += 1
                    if engine.isPlaying {
                        engine.resetTimer()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding(.leading, 30)
            }
            .padding(.bottom, 40)
            
            VStack {
                Text("Pan")
                    .foregroundColor(.white)
                Slider(value: $engine.pan, in: -1.0...1.0, step: 0.1)
                    .accentColor(.accentColor)
                HStack {
                    Text("L")
                        .foregroundColor(.white)
                    Spacer()
                    Text("R")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            // Botão de Play/Pause (centralizado e maior)
            Button(action: {
                if engine.isPlaying {
                       engine.stop()
                   } else {
                       engine.start()
                   }
            }) {
                Image(systemName: engine.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(engine.isPlaying ? .red : .green)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
