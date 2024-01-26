import UIKit

class RegisterController: UIViewController {
    // MARK: - UI Components
   
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpSubTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    private var registerViewModel = RegisterViewModel()

    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    convenience init() {
      self.init(nibName: "RegisterView", bundle: nil) // Burada .xib dosyanızın adını belirtin.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Functions
    @IBAction func didTapSignUp(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            registerViewModel.email = email
            registerViewModel.password = password
            registerViewModel.registerUser()
        } else {
           print("DEBUG PRINT:")
        }
    }
  
    @IBAction func didTapSignIn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
        
    private func bindViewModel() {
           registerViewModel.didStartRegistering = { [weak self] in
               // Update UI to show loading state, e.g., show a spinner
           }
           
           registerViewModel.didRegisterUser = { [weak self] wasRegistered in
               guard let strongSelf = self else { return }
               if wasRegistered {
                   strongSelf.navigateToMainScreen()
               } else {
                   AlertManager.showRegistrationErrorAlert(on: strongSelf)
               }
           }
           
           registerViewModel.didEncounterError = { [weak self] error in
               guard let strongSelf = self else { return }
               AlertManager.showRegistrationErrorAlert(on: strongSelf)
           }
       }
       
       // MARK: - Navigation
       private func navigateToMainScreen() {
           self.navigationController?.popToRootViewController(animated: true)
       }
}
