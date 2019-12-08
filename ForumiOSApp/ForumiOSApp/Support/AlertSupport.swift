
import Foundation
import UIKit

class AlertSupport {
    static func serverError(with text: String?) -> UIAlertController {
        var message = ""
        if text != nil {
            message = text!
        }
        let alert = UIAlertController(title: "Server Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    static func authError(with text: String?) -> UIAlertController {
        var message = "Data is incorrect or account does not exist"
        if text != nil {
            message = text!
        }
        let alert = UIAlertController(title: "Authorisation Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    static func regSuccess(with text: String?) -> UIAlertController {
        var message = "Congratulations! Now you can log in with your details"
        if text != nil {
            message = text!
        }
        let alert = UIAlertController(title: "Registration success", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    static func regError(with text: String?) -> UIAlertController {
        var message = "Invalid creditials"
        if text != nil {
            message = text!
        }
        let alert = UIAlertController(title: "Registration Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    static func getThreadsError(with text: String?) -> UIAlertController {
        var message = "Threads can not be loaded."
        if text != nil {
            message = text!
        }
        let alert = UIAlertController(title: "Server error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    static func getPostsError(with text: String?) -> UIAlertController {
        var message = "Posts can not be loaded."
        if text != nil {
            message = text!
        }
        let alert = UIAlertController(title: "Server error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
}
