import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Cabeçalho
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Register")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Preencha os campos para registrar sua conta")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, -30)
                    
                    Spacer(minLength: 60)
                    
                    // Campos de Entrada
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Email")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        TextField("Digite seu email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Senha")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            ZStack(alignment: .trailing) {
                                if showPassword {
                                    TextField("Digite sua senha", text: $password)
                                } else {
                                    SecureField("Digite sua senha", text: $password)
                                }
                                
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                        }
                    }

                    
                    Spacer(minLength: 240)
                    
          
                    // Botão de Login
                    Button(action: {
                        // validateAndLogin()
                    }) {
                        Text("Entrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            }
        }
    }

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
