import SwiftUI


struct ContinuousPadView: View {
    // Criamos o nosso motor para o pad
    @ObservedObject var engine: ContinuousPadEngine
    
    // O resto da view...
    let notePads: [NotePad] = [
        NotePad(name: "C", soundFileName: "pad_C.mp3"),
        NotePad(name: "C#", soundFileName: "pad_CSharp.mp3"),
        NotePad(name: "D", soundFileName: "pad_D.mp3"),
        NotePad(name: "D#", soundFileName: "pad_DSharp.mp3"),
        NotePad(name: "E", soundFileName: "pad_E.mp3"),
        NotePad(name: "F", soundFileName: "pad_F.mp3"),
        NotePad(name: "F#", soundFileName: "pad_FSharp.mp3"),
        NotePad(name: "G", soundFileName: "pad_G.mp3"),
        NotePad(name: "G#", soundFileName: "pad_GSharp.mp3"),
        NotePad(name: "A", soundFileName: "pad_A.mp3"),
        NotePad(name: "A#", soundFileName: "pad_ASharp.mp3"),
        NotePad(name: "B", soundFileName: "pad_B.mp3")
    ]
    
    @State private var selectedNote: NotePad?
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
           VStack {
               Text("Pad Contínuo")
                   .font(.largeTitle)
                   .fontWeight(.bold)
                   .foregroundColor(.white)
                   .padding(.top)

               LazyVGrid(columns: columns, spacing: 15) {
                   ForEach(notePads) { notePad in
                       Button(action: {
                           self.selectedNote = notePad
                           if engine.isPlaying {
                               engine.play(note: notePad)
                           }
                       }) {
                           Text(notePad.name)
                               .font(.system(size: 24, weight: .bold, design: .rounded))
                               .frame(maxWidth: .infinity, minHeight: 80)
                               // O fundo agora é sempre escuro
                               .background(Color.gray.opacity(0.2))
                               .foregroundColor(.white)
                               // O overlay desenha uma camada por cima (nossa borda)
                               .overlay(
                                   RoundedRectangle(cornerRadius: 10)
                                       .stroke(self.selectedNote == notePad ? Color.accentColor : Color.gray, lineWidth: 3)
                               )
                               .cornerRadius(10)
                       }
                   }
               }
               .padding()

               Spacer()

               // --- CONTROLES PRINCIPAIS NA PARTE DE BAIXO ---
               VStack(spacing: 20) {
                   // Botão de Play/Stop
                   Button(action: {
                       guard let note = selectedNote else { return }
                       if engine.isPlaying {
                           engine.stop()
                       } else {
                           engine.play(note: note)
                       }
                   }) {
                       // Texto e ícone juntos
                       Label(engine.isPlaying ? "Parar Pad" : "Tocar Pad",
                             systemImage: engine.isPlaying ? "stop.fill" : "play.fill")
                           .font(.headline)
                           .foregroundColor(.white)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(engine.isPlaying ? Color.red : Color.accentColor)
                           .cornerRadius(10)
                   }
                   VStack {
                       Text("Volume")
                           .foregroundColor(.white)
                       Slider(value: $engine.volume, in: 0.0...1.0, step: 0.05)
                           .accentColor(.white)
                           .onChange(of: engine.volume) { _ in
                               engine.updateVolume()
                           }
                   }
                   .padding(.horizontal)

                   // Controle de Pan
                   VStack {
                       Text("Pan")
                           .foregroundColor(.white)
                       Slider(value: $engine.pan, in: -1.0...1.0, step: 0.1)
                           .accentColor(.white)
                           .onChange(of: engine.pan) { _ in
                                   // Chama a função para atualizar o pan em tempo real
                                   engine.updatePan()
                               }
                       HStack {
                           Text("L").foregroundColor(.gray)
                           Spacer()
                           Text("R").foregroundColor(.gray)
                       }
                   }
               }
               .padding()
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity)
           .background(Color(red: 0.1, green: 0.1, blue: 0.12)) // Fundo um pouco mais escuro
           // A MÁGICA DA ANIMAÇÃO ACONTECE AQUI
           .animation(.easeInOut(duration: 0.2), value: selectedNote)
           .animation(.easeInOut(duration: 0.2), value: engine.isPlaying)
       }
    
}
