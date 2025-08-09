
import Foundation
import AVFoundation

class SamplerEngine: ObservableObject {
    @Published var pan: Float = 0.0
    
    // Um dicionário para guardar um player para cada som.
    private var players: [String: AVAudioPlayer] = [:]

    // O init agora recebe os pads para saber quais sons carregar.
    init(pads: [Pad]) {
        loadSounds(for: pads)
    }

    private func loadSounds(for pads: [Pad]) {
        for pad in pads {
            guard let soundURL = Bundle.main.url(forResource: pad.soundFileName, withExtension: nil) else {
                print("Não foi possível encontrar o arquivo: \(pad.soundFileName)")
                continue // Pula para o próximo pad se não encontrar o som
            }
            
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer.prepareToPlay()
                players[pad.soundFileName] = audioPlayer // Guarda o player no dicionário
            } catch {
                print("Erro ao carregar o som \(pad.soundFileName): \(error.localizedDescription)")
            }
        }
    }

    func play(soundFileName: String) {
        // Busca o player correto no dicionário
        guard let player = players[soundFileName] else {
            print("Player não encontrado para o som: \(soundFileName)")
            return
        }
        
        player.pan = self.pan // Aplica o pan
        player.currentTime = 0 // Reinicia o som para tocar do início
        player.play()
    }
}
