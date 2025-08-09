//
//  CombinedView.swift
//  worship-sampler
//
//  Created by Jose campos on 08/08/25.
//


import SwiftUI

struct CombinedView: View {
    // 1. Recebe TODOS os motores do pai
    @ObservedObject var metronomeEngine: MetronomeEngine
    @ObservedObject var samplerEngine: SamplerEngine
    @ObservedObject var padEngine: ContinuousPadEngine
    let samplerPads: [Pad]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // --- Seção do Metrônomo ---
                GroupBox("Metrônomo") {
                    MetronomeView(engine: metronomeEngine)
                }

                // --- Seção do Sampler ---
                GroupBox("Drum Sampler") {
                    // Aqui, em vez de recriar a View inteira,
                    // podemos só colocar os controles essenciais.
                    // Mas para simplificar, vamos reutilizar a View que já temos.
                    DrumSamplerView(engine: samplerEngine, pads: samplerPads )
                }
                
                // --- Seção do Pad Contínuo ---
                GroupBox("Pad Contínuo") {
                    ContinuousPadView(engine: padEngine)
                }
            }
            .padding()
        }
    }
}
