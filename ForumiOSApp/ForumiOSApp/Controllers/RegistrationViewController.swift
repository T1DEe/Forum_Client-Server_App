
import UIKit

class RegistrationViewController: UIViewController {
    
    let sex = ["male", "female"]
    @IBOutlet weak var sexPicker: UIPickerView!
    @IBOutlet weak var birthPicker: UIDatePicker!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        birthPicker.minimumDate = Date(timeIntervalSince1970: -2208988800)
        birthPicker.maximumDate = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sexPicker.tintColor = .white
        
    }


}


extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sex.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sex[row]
    }
    
    
}
