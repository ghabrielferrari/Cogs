//
//  IdeasViewModel.swift
//  Cogs
//
//  Created by Aluno 17 on 12/06/25.
//

import Foundation
import SwiftUI

// MARK: - ViewModel
/// Gerencia o estado e a lógica da tela de ideias.
class IdeasViewModel: ObservableObject {
    @Published var postIts: [PostIt] = [
        PostIt(id: 1, text: "Ideias demais aí como eu tenho ideias", tag: "Liderança", color: .yellow),
        PostIt(id: 2, text: "Estratégia de redes sociais", tag: "Marketing", color: .green),
        PostIt(id: 3, text: "Plano de negócios 2025", tag: "Empreendimento", color: .blue),
        PostIt(id: 4, text: "Nova campanha publicitária", tag: "Marketing", color: .pink),
        PostIt(id: 5, text: "Controle de gastos mensais", tag: "Finanças", color: .purple)
    ]
    @Published var notes: [String] = [
        "Aqui tem uma anotação do usuário, bla bla bla, ter um empreendimento",
        "Reunião com equipe de marketing na próxima terça",
        "Preciso revisar o orçamento do projeto"
    ]
    @Published var selectedTag: Tag = .todas
    
    /// Filtra os post-its com base na tag selecionada.
    var filteredPostIts: [PostIt] {
        selectedTag == .todas ? postIts : postIts.filter { $0.tag == selectedTag.rawValue }
    }
    
    /// Divide os post-its em chunks de 2 para exibição em grade.
    func chunkedPostIts() -> [[PostIt]] {
        stride(from: 0, to: filteredPostIts.count, by: 2).map { index in
            Array(filteredPostIts[index..<min(index + 2, filteredPostIts.count)])
        }
    }
    
    /// Seleciona uma tag para filtrar os post-its.
    func selectTag(_ tag: Tag) {
        selectedTag = tag
    }
    
    /// Adiciona um novo post-it (exemplo de mutação).
    func addPostIt(text: String, tag: String, color: Color) {
        let newId = postIts.map { $0.id }.max() ?? 0 + 1
        let newPostIt = PostIt(id: newId, text: text, tag: tag, color: color)
        postIts.append(newPostIt)
    }
}
