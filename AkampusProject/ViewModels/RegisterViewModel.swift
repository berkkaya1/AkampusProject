class RegisterViewModel {
    
    var email: String = ""
    var password: String = ""
    var userPoints: Int = 0
    
    
    var didStartRegistering: (() -> Void)?
    var didRegisterUser: ((Bool) -> Void)?
    var didEncounterError: ((Error?) -> Void)?
    
  
    private let authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
    }
    
    
    func registerUser() {
        guard Validator.isValidEmail(for: email) else {
            didEncounterError?(nil)
            return
        }
        
        let registerUserRequest = RegisterUserRequest(email: email, password: password, userPoint: userPoints)
        
      
        didStartRegistering?()
        
        authService.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            if let error = error {
                self?.didEncounterError?(error)
            } else {
                self?.didRegisterUser?(wasRegistered)
            }
        }
    }
}
