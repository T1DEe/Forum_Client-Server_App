
import UIKit

class RegistrationViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        locationField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        genderPicker.tintColor = .white
    }
    
    //MARK: Buttons actions
    @IBAction func registrationBtnTapped(_ sender: UIButton) {
        guard !isFieldsEmpty() else { return }
        
        let url = URL(string: "http://localhost:5000/registerUser")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "username": usernameField.text!,
            "password": passwordField.text!,
            "location": locationField.text!,
            "sex": genderPicker.selectedRow(inComponent: 0)
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
            let accessResult = String(data: data, encoding: .utf8)!
            print("regUser(): \(String(describing: accessResult))")
            
            DispatchQueue.main.async {
                if accessResult == "true" {
                    self.present(AlertSupport.regSuccess(with: nil), animated: true)
                } else if accessResult == "false" {
                    self.present(AlertSupport.regError(with: nil), animated: true)
                } else {
                    fatalError()
                }
            }
            
        }

        task.resume()
    }
    
    //MARK: Functions (private)
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

//MARK: GenderPickerDataSource
extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Genders.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Genders.allCases[row].rawValue
    }
}


//MARK: UITextFiedl Delegate
extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == usernameField {
            let currentText = textField.text! + string
            return currentText.count <= 10
        } else if textField == passwordField {
            let currentText = textField.text! + string
            return currentText.count <= 10
        } else if textField == locationField {
            let currentText = textField.text! + string
            return currentText.count <= 10
        }
        
        return true;
    }
}
