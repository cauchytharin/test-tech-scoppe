//
//  ViewController.swift
//  scoppe
//
//  Created by Billy Cauchy-Tharin on 20/01/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProfileViewController {
            vc.user = user
            vc.getUserInfo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        if notification.name == UIResponder.keyboardWillShowNotification ||
//            notification.name == UIResponder.keyboardWillChangeFrameNotification {
//            let hiddenTextFieldHeight = keyboardRect.minY - passwordTextField.frame.maxY - 10
//            if hiddenTextFieldHeight < 0 {
//                // causes some wierd behaviour in landscape mode (zooms the view while textfield selected)
//                self.view.frame.origin.y = hiddenTextFieldHeight
//            }
//        } else {
//            view.frame.origin.y = 0
//        }
    }
    
    
    private func loginUser(email: String = "eve.holt@reqres.in", password: String = "cityslicka") {
        let urlString = "https://reqres.in/api/register"
        let parameters = [
            "email": email,
            "password": password,
        ]
        AF.request(urlString, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let token = json["token"].string {
                        let id = json["id"].stringValue
                        self.user = User(token: token, id: id)
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    } else {
                        self.showInvalidLoginAlert()
                    }
                case .failure(let error):
                    print("Login error: \(error)")
                    self.showInvalidLoginAlert()
                }
        }
    }
    
    func showInvalidLoginAlert() {
        showAlert(title: "Connexion échoué",
                  message: "Il y a eu une erreur lors de la connection. Veuillez réessayer avec une adresse email et un mot de passe valide.")
    }
    
    func forgotPasswordAlert() {
        showAlert(title: "Mot de passe oublié",
                  message: "Un email vous sera envoyé pour réinitialiser votre mot de passe.")
    }
    
    func showAlert(title: String, message: String) {
        hideKeyboard()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func getUserInputForLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        if email == "" || password == "" {
            loginUser()
//            showInvalidLoginAlert()
        } else {
            loginUser(email: email, password: password)
        }
    }
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        getUserInputForLogin()
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        forgotPasswordAlert()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        hideKeyboard()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            getUserInputForLogin()
        }
        return true
    }
}

