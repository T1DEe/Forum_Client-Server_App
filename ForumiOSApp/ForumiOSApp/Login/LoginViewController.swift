
import UIKit

class LoginViewController: UIViewController {
    
    //@IBOutlet var contentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        mainView.layer.borderWidth = 10
        mainView.layer.cornerRadius = 10
        mainView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        loginBtn.layer.cornerRadius = 5
    }
    
    
    @IBAction func registrationTapped(_ sender: UIButton) {
        let registrationVC = RegistrationViewController()
        
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}
