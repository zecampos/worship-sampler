import SwiftUI

struct ContentView: View {
    @StateObject private var metronomeEngine = MetronomeEngine()
    @StateObject private var samplerEngine: SamplerEngine
    @StateObject private var padEngine = ContinuousPadEngine()
    //@StateObject private var metronomeEngine = MetronomeEngine()
    let samplerPads: [Pad]

    init() {
        let pads: [Pad] = [
        Pad(name: "Kick", soundFileName: "kick.wav", color: .red),
        Pad(name: "Snare", soundFileName: "snare.wav", color: .blue),
        Pad(name: "Hi-Hat", soundFileName: "hihat.wav", color: .yellow),
        Pad(name: "Clap", soundFileName: "clap.wav", color: .orange),
        Pad(name: "LongKick", soundFileName: "LongKick.wav", color: .purple),
        Pad(name: "Tambourin", soundFileName: "Tambourin.wav", color: .green)
        ]

    self.samplerPads = pads
    _samplerEngine = StateObject(wrappedValue: SamplerEngine(pads: pads))
    }
    var body: some View {
    TabView {
    // Aba 1: Metrônomo
    MetronomeView(engine: metronomeEngine)
    .tabItem {
    Label("Metrônomo", systemImage: "metronome")
    }

    // Aba 2: Pad Contínuo
    ContinuousPadView(engine: padEngine)
    .tabItem {
    Label("Pad", systemImage: "waveform.path")
    }

    // Aba 3: Drum Sampler
    DrumSamplerView(engine: samplerEngine, pads: samplerPads)
    .tabItem {
    Label("Sampler", systemImage: "squares.below.rectangle")
    }

//// Aba 4: Combinado
//CombinedView(metronomeEngine: metronomeEngine, samplerEngine: samplerEngine, padEngine: padEngine, samplerPads: samplerPads)
//.tabItem {
//Label("Ao Vivo", systemImage: "music.mic")
//}
}
}
}
//#Preview {
//ContentView()
//}
