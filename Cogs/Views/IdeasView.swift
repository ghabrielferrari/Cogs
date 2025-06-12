import SwiftUI

struct IdeasView: View {
    // Tags disponíveis para filtro
    private let tags = ["Liderança", "Marketing", "Empreendimento", "Finanças", "Produtividade", "Criatividade"]
    @State private var selectedTag: String = "Liderança"
    
    // Dados de exemplo para os post-its
    @State private var postIts: [PostIt] = [
        PostIt(id: 1, text: "Ideias demais aí como eu tenho ideias", tag: "Liderança", color: .yellow),
        PostIt(id: 2, text: "Estratégia de redes sociais", tag: "Marketing", color: .green),
        PostIt(id: 3, text: "Plano de negócios 2025", tag: "Empreendimento", color: .blue),
        PostIt(id: 4, text: "Nova campanha publicitária", tag: "Marketing", color: .pink),
        PostIt(id: 5, text: "Controle de gastos mensais", tag: "Finanças", color: .purple)
    ]
    
    // Anotações do usuário
    @State private var notes: [String] = [
        "Aqui tem uma anotação do usuário, bla bla bla, ter um empreendimento",
        "Aqui tem uma anotação do usuário, bla bla bla, ter um empreendimento",
        "Reunião com equipe de marketing na próxima terça",
        "Preciso revisar o orçamento do projeto"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Seção de Tags (Scroll horizontal)
                    tagsSection
                    
                    // Seção de Post-its (Grid de 2 linhas)
                    postItsGridSection
                    
                    // Seção de Anotações
                    notesSection
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Ideias")
        }
    }
    
    // MARK: - Componentes
    
    private var tagsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(tags, id: \.self) { tag in
                    TagView(
                        title: tag,
                        isSelected: selectedTag == tag,
                        action: { selectedTag = tag }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var postItsGridSection: some View {
        let filteredPostIts = postIts.filter { selectedTag == "Todas" || $0.tag == selectedTag }
        let chunkedPostIts = filteredPostIts.chunked(into: 2) // 2 itens por linha
        
        return VStack(spacing: 16) {
            ForEach(chunkedPostIts.indices, id: \.self) { rowIndex in
                HStack(spacing: 16) {
                    ForEach(chunkedPostIts[rowIndex]) { postIt in
                        PostItView(postIt: postIt)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anotações")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            
            VStack(spacing: 12) {
                ForEach(notes.indices, id: \.self) { index in
                    NoteView(text: notes[index])
                }
            }
        }
    }
}

// MARK: - Modelos e Extensões

struct PostIt: Identifiable {
    let id: Int
    let text: String
    let tag: String
    let color: Color
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Componentes Reutilizáveis

struct TagView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PostItView: View {
    let postIt: PostIt
    
    var body: some View {
        VStack {
            Text(postIt.text)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding()
        }
        .frame(width: 160, height: 120)
        .background(postIt.color)
        .cornerRadius(8)
        .shadow(radius: 3)
    }
}

struct NoteView: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "note.text")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            Text(text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Preview

struct IdeasView_Previews: PreviewProvider {
    static var previews: some View {
        IdeasView()
    }
}
