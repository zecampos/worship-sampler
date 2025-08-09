import SwiftUI

// Modelo para os pads do sampler
struct Pad: Identifiable {
    let id = UUID()
    let name: String
    let soundFileName: String
    let color: Color
}

// Modelo para as notas do pad contínuo
struct NotePad: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let soundFileName: String
}
