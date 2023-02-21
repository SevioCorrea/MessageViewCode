//
//  RegisterViewController.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 16/02/23.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    var registerScreen: RegisterScreen?
    
    var auth: Auth?
    var firestore: Firestore?
    var alert: Alert?
    
    override func loadView() {
        self.registerScreen = RegisterScreen()
        self.view = self.registerScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerScreen?.delegate(delegate: self)
        // Ou self.registerScreen?.delegate = self
        self.registerScreen?.configTextFieldDelegate(delegate: self)
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.alert = Alert(controller: self)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.registerScreen?.validaTextFields()
    }
}


extension RegisterViewController: RegisterScreenProtocol {
    func actionRegisterButton() {
        
        guard let register = self.registerScreen else {return}
        
        let email: String = register.getEmail()
        let password: String = register.getPassword()
        
        self.auth?.createUser(withEmail: email, password: password, completion: { result, error in
            
            if error != nil {
                self.alert?.getAlert(titulo: "Atenção", mensagem: "\(String(describing: error!.localizedDescription))")
            } else {
                
                
                // Salvar Dados no Firebase
                if let idUsuario = result?.user.uid { // Todo usuário tem um UID no Firebase
                    self.firestore?.collection("usuarios").document(idUsuario).setData([
                        "nome": self.registerScreen?.getName() ?? "",
                        "email": self.registerScreen?.getEmail() ?? "",
                        "id": idUsuario
                    ])
                }
                
                
                self.alert?.getAlert(titulo: "Sucesso", mensagem: "Sucesso ao Registrar.", completion: {
                    
                    
                    self.navigationController?.popViewController(animated: true)
                })
            }
        })
    }
}
