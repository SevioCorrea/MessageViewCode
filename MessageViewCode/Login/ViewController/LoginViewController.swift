//
//  LoginViewController.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 16/02/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var loginScreen: LoginScreen?
    var auth: Auth?
    var alert: Alert?
    
    override func loadView() {
        self.loginScreen = LoginScreen()
        self.view = self.loginScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginScreen?.delegate(delegate: self)
        // Ou self.loginScreen?.delegate = self
        self.loginScreen?.configTextFieldDelegate(delegate: self)
        self.auth = Auth.auth()
        self.alert = Alert(controller: self)
        
    }
    
    /// Ocultando a Navigation Bar do topo da tela
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.loginScreen?.validaTextFields()
    }
    
    
}

extension LoginViewController: LoginScreenProtocol {
    func actionLoginButton() {
        
        guard let login = self.loginScreen else { return }

        let email: String = login.getEmail()
        let password: String = login.getPassword()

        self.auth?.signIn(withEmail: email, password: password, completion: { usuario, error in

            if error != nil {
                self.alert?.getAlert(titulo: "Atenção", mensagem: "\(String(describing: error!.localizedDescription))")
            } else {

                if usuario == nil {
                    self.alert?.getAlert(titulo: "Atenção", mensagem: "Tivemos um problema. Tente novamente mais tarde.")
                } else {
                    self.alert?.getAlert(titulo: "Sucesso", mensagem: "Sucesso ao Logar.")
                }
            }
        })
        
    }
    
    func actionRegisterButton() {
        let vc: RegisterViewController = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
