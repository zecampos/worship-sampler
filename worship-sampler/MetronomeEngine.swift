import Foundation
import AVFoundation // Framework da Apple para áudio e vídeo

class MetronomeEngine: ObservableObject {
    // @Published para que a View possa observar essas propriedades
    @Published var bpm: Double = 120.0
    @Published var isPlaying: Bool = false
    @Published var pan: Float = 0.0 // -1.0 (L) para 1.0 (R)
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?

    init() {
        setupAudioPlayer()
    }
    

    private func setupAudioPlayer() {
        // MUITO IMPORTANTE: Mude "seu_som" para o nome exato do seu arquivo de áudio
        // e "mp3" para a extensão correta (.wav, etc.)
        guard let soundURL = Bundle.main.url(forResource: "tick", withExtension: "mp3") else {
            print("ARQUIVO DE SOM DO METRÔNOMO NÃO ENCONTRADO! Verifique o nome e a extensão.")
            return
        }
        print("Arquivo de som do metrônomo encontrado em: \(soundURL)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            print("Player de áudio do metrônomo configurado com sucesso!")
        } catch {
            print("Erro ao carregar o player de áudio: \(error.localizedDescription)")
        }
    }

    func start() {
        guard !isPlaying else { return }
        isPlaying = true
        
        let timeInterval = 60.0 / bpm
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.playTick()
        }
    }

    func stop() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }

    private func playTick() {
        audioPlayer?.pan = self.pan // Define o pan antes de tocar
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
    // Adicionamos uma função para reiniciar o timer quando o BPM muda manualmente
    func resetTimer() {
    self.stop()
    self.start()
    }
    
}
