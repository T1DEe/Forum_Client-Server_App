
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Buttons actions
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        guard !isFieldsEmpty() else { return }
        
        let url = URL(string: "http://localhost:5000/authUser")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "username": "\(usernameField.text!)",
            "password": "\(passwordField.text!)"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil
                else {
                    print("error", error ?? "Unknown error")
                    DispatchQueue.main.async {
                        self.present(AlertSupport.serverError(with: nil), animated: true)
                    }
                    return
                }

            if let authUser = try? JSONDecoder().decode(User.self, from: data) {
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.currentUser = authUser
                    let threadsVC = self.storyboard?.instantiateViewController(withIdentifier: "MainNavVC") as! UINavigationController
                    self.present(threadsVC, animated: true)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.present(AlertSupport.authError(with: nil), animated: true)
                }
            }
        }
        task.resume()
    }
    @IBAction func registrationTapped(_ sender: UIButton) {
        let registrationVC = storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationViewController
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    //MARK: Functions (private)
    private func setupView() {
        mainView.layer.borderWidth = 10
        mainView.layer.cornerRadius = 10
        mainView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        loginBtn.layer.cornerRadius = 5
    }
    
    
    private func isFieldsEmpty() -> Bool {
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty {
            warningLabel.textColor = .red
            return true
        } else {
            warningLabel.textColor = UIColor.hexStringToUIColor(hex: "#0096FF")
            return false
        }
    }
    
    
}


//MARK: UITextFiedl Delegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == usernameField {
            let currentText = textField.text! + string
            return currentText.count <= 20
        } else if textField == passwordField {
            let currentText = textField.text! + string
            return currentText.count <= 20
        }
        
        return true;
    }
}
