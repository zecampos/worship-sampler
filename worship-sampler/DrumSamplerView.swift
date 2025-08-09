//
//  DrumSamplerView.swift
//  worship-sampler
//
//  Created by Jose campos on 08/08/25.
//


import SwiftUI

struct Pad: Identifiable {
    let id = UUID() // Identificador único para a lista
    let name: String
    let soundFileName: String
    let color: Color
}

struct DrumSamplerView: View {


    // Por enquanto, uma lista simples com os nomes dos nossos pads
  
    let pads: [Pad]
//    @StateObject private var engine: SamplerEngine
    @ObservedObject var engine: SamplerEngine
       
    
    var body: some View {
           VStack {
               let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

               LazyVGrid(columns: columns, spacing: 20) {
                   ForEach(pads) { pad in
                       Button(action: {
                           // A ação agora chama a função play do nosso motor!
                           engine.play(soundFileName: pad.soundFileName)
                       }) {
                           Text(pad.name)
                               .font(.title)
                               .fontWeight(.bold)
                               .frame(maxWidth: .infinity, minHeight: 100)
                               .background(pad.color.opacity(0.8))
                               .cornerRadius(10)
                               .foregroundColor(.white)
                       }
                   }
               }
               .padding()
               
               // Adicionamos o controle de Pan para o sampler
               VStack {
                   Text("Pan")
                   Slider(value: $engine.pan, in: -1.0...1.0, step: 0.1)
                   HStack {
                       Text("L")
                       Spacer()
                       Text("R")
                   }
               }
               .padding()
           }
       }


}
