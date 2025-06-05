//
//  ContentView.swift
//  Cogs
//
//  Created by Aluno 17 on 28/05/25.
//

import SwiftUI

struct ContentView: View {
@State private var Tag: String = ""

    var body: some View {
        VStack{
            Text("This is a test Core Data App!")
                .padding()
            HStack{
                TextField("Tag name", text: $Tag)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action:{
                    saveTag()
                }){
                    Image(systemName: "plus.circle.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(60)
                }
                .disabled(Tag.isEmpty)
                .padding()
            }
            
        }
    }
}

private func saveTag(){
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
