import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var tagInput: String = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    var body: some View {
        VStack {
            Text("This is a test Core Data App!")
                .padding()
            
            HStack {
                TextField("Tag name", text: $tagInput)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button(action: {
                    saveTag()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(60)
                }
                .disabled(tagInput.isEmpty)
                .padding()
            }
            
            // Display saved tags
            List {
                ForEach(tags) { tag in
                    HStack {
                        Text(tag.name ?? "Unknown")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        
                        Button(action: {
                            deleteTag(tag)
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
    
    private func saveTag() {
        let newTag = Tag(context: viewContext)
        newTag.name = tagInput
        
        do {
            try viewContext.save()
            tagInput = ""
        } catch {
            print("Failed to save tag: \(error.localizedDescription)")
        }
    }
    
    private func deleteTag(_ tag: Tag) {
        viewContext.delete(tag)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete tag: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
