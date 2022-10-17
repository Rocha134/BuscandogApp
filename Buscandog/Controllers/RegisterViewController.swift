//
//  RegisterViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 13/10/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    private let db = Firestore.firestore()
    
    @IBOutlet weak var cellphoneNumberTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text,
           let cellphoneNumber = cellphoneNumberTextField.text,
           let name = nameTextField.text,
           let lastName = lastNameTextfield.text,
           let confirmPassword = confirmPasswordTextField.text,
           let password = passwordTextfield.text,
           password == confirmPassword{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                } else {
                    //Añadimos los datos del usuario a la base de datos
                    self.db.collection(K.FStore.collectionNameUsers).document(email).setData(
                        [
                            K.FStore.emailField: email,
                            K.FStore.cellPhoneNumberField: cellphoneNumber,
                            K.FStore.nameField: name,
                            K.FStore.lastNameField: lastName,
                            K.FStore.accountCreatedDateField: Date().timeIntervalSince1970
                    ])
                    //Mantenemos la sesion iniciada
                    self.defaults.set(true, forKey: "KeepSignIn")
                    //Navigate to the Home ViewController
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
            
        }
        
    }
    
}
