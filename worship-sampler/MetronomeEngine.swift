import Foundation
import AVFoundation

class MetronomeEngine: ObservableObject {
    @Published var bpm: Double = 120.0
    @Published var isPlaying: Bool = false
    @Published var pan: Float = 0.0
    @Published var isAccentEnabled: Bool = true // Começa ligado por padrão

    @Published var beatsPerMeasure: Int = 4 // Para o 4/4, 3/4, etc.
    @Published var currentBeat: Int = 0 // Contador interno de batidas

    private var timer: Timer?
    // --- DOIS PLAYERS DE ÁUDIO ---
 private var regularTickPlayer: AVAudioPlayer?
 private var accentTickPlayer: AVAudioPlayer?

 init() {
  setupAudioPlayers()
 }

 private func setupAudioPlayers() {
  // Carrega o som do tick normal
  guard let regularTickURL = Bundle.main.url(forResource: "tick", withExtension: "mp3") else {
   print("Não foi possível encontrar o arquivo: tick.mp3")
   return
  }
  do {
   regularTickPlayer = try AVAudioPlayer(contentsOf: regularTickURL)
   regularTickPlayer?.prepareToPlay()
  } catch {
   print("Erro ao carregar o tick regular: \(error.localizedDescription)")
  }

  // Carrega o som do tick acentuado
  // MUDE "accent_tick.wav" para o nome do seu arquivo de acento
  guard let accentTickURL = Bundle.main.url(forResource: "accent", withExtension: "mp3") else {
   print("Não foi possível encontrar o arquivo de acento.")
   return
  }
  do {
   accentTickPlayer = try AVAudioPlayer(contentsOf: accentTickURL)
   accentTickPlayer?.prepareToPlay()
  } catch {
   print("Erro ao carregar o tick de acento: \(error.localizedDescription)")
  }
 }

 func start() {
  guard !isPlaying else { return }

  currentBeat = 0 // Reseta a contagem sempre que começa a tocar
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

 // --- LÓGICA DE CONTAGEM E ACENTO ---
 private func playTick() {
  currentBeat = (currentBeat % beatsPerMeasure) + 1

  // AQUI ESTÁ A NOVA LÓGICA:
  // Toca o acento SÓ SE isAccentEnabled for verdadeiro E for a batida 1
  if isAccentEnabled && currentBeat == 1 {
   accentTickPlayer?.pan = self.pan
   accentTickPlayer?.currentTime = 0
   accentTickPlayer?.play()
  } else {
   // Em todos os outros casos, toca o tick normal
   regularTickPlayer?.pan = self.pan
   regularTickPlayer?.currentTime = 0
   regularTickPlayer?.play()
  }
 }

 func resetTimer() {
  // Para, e imediatamente começa de novo com as novas configurações (BPM)
  self.stop()
  self.start()
 }

 // ... (a função resetTimer continua a mesma) ...
}
