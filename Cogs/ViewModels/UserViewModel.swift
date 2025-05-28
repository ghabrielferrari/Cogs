import Foundation

class UserViewModel: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"

    // Salvar usuário no UserDefaults
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
            print("Usuário salvo: \(user)")
        }
    }

    // Recuperar usuário do UserDefaults
    func getUser() -> User? {
        if let data = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }

    // Verificar se o login é válido
    func isValidLogin(email: String, password: String) -> Bool {
        if let user = getUser() {
            print("Usuário recuperado: \(user)")
            return user.email == email && user.password == password
        }
        return false
    }

    // Limpar dados do usuário (logout, se necessário)
    func clearUser() {
        userDefaults.removeObject(forKey: userKey)
    }
}
