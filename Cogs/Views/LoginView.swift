import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = UserViewModel() // Instancia o ViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var selectedTab: AuthTab = .login
    @State private var name: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoggedIn: Bool = false // Controla navegação após login

    enum AuthTab {
        case login, register
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                // Cabeçalho
                VStack(spacing: 8) {
                    Text("Boas vindas!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Esperamos que você cresça conosco")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Seção de Abas
                VStack(spacing: 0) {
                    HStack(spacing: 40) {
                        Button(action: {
                            withAnimation {
                                selectedTab = .login
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text("Login")
                                    .font(.headline)
                                    .foregroundColor(selectedTab == .login ? .primary : .gray)
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedTab == .login ? .blue : .clear)
                            }
                        }

                        Button(action: {
                            withAnimation {
                                selectedTab = .register
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text("Cadastro")
                                    .font(.headline)
                                    .foregroundColor(selectedTab == .register ? .primary : .gray)
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedTab == .register ? .blue : .clear)
                            }
                        }
                    }
                    .padding(.bottom, 16)

                    if selectedTab == .login {
                        loginContent()
                    } else {
                        registerContent()
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erro"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            // Navegação para tela de sucesso após login
            .background(
                NavigationLink(
                    destination: WelcomeView(user: viewModel.getUser()),
                    isActive: $isLoggedIn,
                    label: { EmptyView() }
                )
            )
        }
    }

    @ViewBuilder
    private func loginContent() -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                passwordField(placeholder: "Senha", text: $password, showPassword: $showPassword)
            }

            Button(action: validateAndLogin) {
                Text("Entrar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            HStack {
                Spacer()
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Esqueceu a senha? Clique aqui")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func registerContent() -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                TextField("Nome", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                passwordField(placeholder: "Senha", text: $password, showPassword: $showPassword)

                passwordField(placeholder: "Confirmar senha", text: $confirmPassword, showPassword: $showConfirmPassword)
            }

            Button(action: validateAndRegister) {
                Text("Criar conta")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    @ViewBuilder
    private func passwordField(placeholder: String, text: Binding<String>, showPassword: Binding<Bool>) -> some View {
        ZStack(alignment: .trailing) {
            if showPassword.wrappedValue {
                TextField(placeholder, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                SecureField(placeholder, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button(action: { showPassword.wrappedValue.toggle() }) {
                Image(systemName: showPassword.wrappedValue ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
        }
    }
    
    // Função para limpar os campos
        private func clearFields() {
            email = ""
            password = ""
            name = ""
            confirmPassword = ""
            showPassword = false
            showConfirmPassword = false
        }

    func validateAndLogin() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Por favor, preencha todos os campos."
            showAlert = true
            return
        }

        let isValidEmail = email.contains("@") && email.contains(".")
        let isValidPassword = password.count >= 6

        if !isValidEmail {
            alertMessage = "Email inválido. Por favor, insira um email válido."
            showAlert = true
            return
        }

        if !isValidPassword {
            alertMessage = "Senha inválida. A senha deve conter pelo menos 6 caracteres."
            showAlert = true
            return
        }

        if viewModel.isValidLogin(email: email, password: password) {
            clearFields() // Limpa os campos após login bem-sucedido
            isLoggedIn = true // Navega para a próxima tela
        } else {
            alertMessage = "Email ou senha incorretos."
            showAlert = true
        }
    }

    func validateAndRegister() {
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Por favor, preencha todos os campos."
            showAlert = true
            return
        }

        let isValidEmail = email.contains("@") && email.contains(".")
        let isValidPassword = password.count >= 6
        let passwordsMatch = password == confirmPassword

        if !isValidEmail {
            alertMessage = "Email inválido. Por favor, insira um email válido."
            showAlert = true
            return
        }

        if !isValidPassword {
            alertMessage = "Senha inválida. A senha deve conter pelo menos 6 caracteres."
            showAlert = true
            return
        }

        if !passwordsMatch {
            alertMessage = "As senhas não coincidem. Por favor, verifique."
            showAlert = true
            return
        }

        // Salvar usuário
        let user = User(name: name, email: email, password: password)
        viewModel.saveUser(user)
        print("Cadastro bem-sucedido! Nome: \(name), Email: \(email)")
        clearFields() // Limpa os campos após login bem-sucedido
        isLoggedIn = true // Navega para a próxima tela
    }
}

// Tela de boas-vindas após login/cadastro
struct WelcomeView: View {
    let user: User?

    var body: some View {
        VStack {
            Text("Bem-vindo, \(user?.name ?? "Usuário")!")
                .font(.largeTitle)
                .padding()
            Text("Email: \(user?.email ?? "N/A")")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .navigationTitle("Bem-vindo")
    }
}

struct ForgotPasswordView: View {
    var body: some View {
        Text("Recuperar Senha")
            .navigationTitle("Recuperar Senha")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
