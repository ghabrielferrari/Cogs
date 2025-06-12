import SwiftUI

// MARK: - Models
/// Representa um post-it com texto, tag e cor.
struct PostIt: Identifiable {
    let id: Int
    let text: String
    let tag: String
    let color: Color
    
    /// Valida se o texto não está vazio.
    var isValid: Bool {
        !text.isEmpty
    }
}

/// Enumera as tags disponíveis.
enum Tag: String, CaseIterable {
    case todas = "Todas"
    case liderança = "Liderança"
    case marketing = "Marketing"
    case empreendimento = "Empreendimento"
    case finanças = "Finanças"
    case produtividade = "Produtividade"
    case criatividade = "Criatividade"
}
