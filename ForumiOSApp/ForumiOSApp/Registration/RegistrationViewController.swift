
import UIKit


class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var birthPicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthPicker.minimumDate = Date(timeIntervalSince1970: -2208988800)
        birthPicker.maximumDate = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        genderPicker.tintColor = .white
        
    }
}


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
