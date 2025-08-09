import Foundation
import AVFoundation

class ContinuousPadEngine: ObservableObject {
    @Published var isPlaying = false
    @Published var pan: Float = 0.0
    @Published var volume: Float = 1.0 // 0.0 (silêncio) a 1.0 (máximo)
    
    private var audioPlayer: AVAudioPlayer?

    func play(note: NotePad) {
        // Para o player antigo, se existir
        stop()
        audioPlayer?.volume = self.volume
        guard let soundURL = Bundle.main.url(forResource: note.soundFileName, withExtension: nil) else {
            print("Não foi possível encontrar o arquivo: \(note.soundFileName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.pan = self.pan
            // A mágica do loop contínuo acontece aqui:
            // -1 significa que ele vai tocar para sempre.
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Erro ao tocar o som do pad: \(error.localizedDescription)")
            isPlaying = false
        }
    }

    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        audioPlayer = nil // Libera o player da memória
    }
    
    // Função para atualizar o pan enquanto o som já está tocando
    func updatePan() {
        audioPlayer?.pan = self.pan
    }
    func updateVolume() {
        audioPlayer?.volume = self.volume
    }
}
