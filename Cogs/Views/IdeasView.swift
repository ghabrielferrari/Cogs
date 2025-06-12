import SwiftUI

// MARK: - Main View
struct IdeasView: View {
    // MARK: - Properties
    @StateObject private var viewModel = IdeasViewModel()
    
    // MARK: - Constants
    private enum Constants {
        static let postItSize = CGSize(width: 160, height: 120)
        static let cornerRadius: CGFloat = 8
        static let shadowRadius: CGFloat = 3
        static let spacing: CGFloat = 20
        static let tagSpacing: CGFloat = 12
    }
    
    // MARK: - Main Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.spacing) {
                    tagsSection
                    postItsGridSection
                    notesSection
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Ideias")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - View Components
    private var tagsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.tagSpacing) {
                ForEach(Tag.allCases, id: \.self) { tag in
                    TagView(
                        title: tag.rawValue,
                        isSelected: viewModel.selectedTag == tag,
                        action: { viewModel.selectTag(tag) }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var postItsGridSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.chunkedPostIts().indices, id: \.self) { rowIndex in
                HStack(spacing: 16) {
                    ForEach(viewModel.chunkedPostIts()[rowIndex], id: \.id) { postIt in
                        PostItView(postIt: postIt)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Alinha à esquerda
            }
        }
        .padding(.vertical, 8)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anotações")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            VStack(spacing: 12) {
                ForEach(viewModel.notes, id: \.self) { note in
                    NoteView(text: note)
                }
            }
        }
    }
}

// MARK: - Component Views
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

// MARK: - Extensions
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}
