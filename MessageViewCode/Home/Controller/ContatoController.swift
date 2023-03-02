//
//  ContatoController.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 02/03/23.
//

import Foundation
import UIKit
import Firebase


protocol ContatoProtocol: AnyObject {
    func alertStateError(titulo: String, message: String)
    func successContato()
}

class ContatoController {
    
    weak var delegate: ContatoProtocol?
    
    public func delegate(delegate: ContatoProtocol?) {
        self.delegate = delegate
    }
    
    func addContact(email: String, emailUsuarioLogado: String, idUsuario: String) {
        
        if email == emailUsuarioLogado { // Verificar se está tentando adicionar você mesmo.
            self.delegate?.alertStateError(titulo: "Você adicionou seu próprio email.", message: "Adicione um email diferente.")
            return
        }
        
        // Verificar se existe o usuário no Firebase.
        // Verificando a coleção "usuarios" criada no Firebase onde armazena os dados dos usuários.
        let firestore = Firestore.firestore()
        firestore.collection("usuarios").whereField("email", isEqualTo: email).getDocuments { snapshotResultado, error in
            
            // Conta total de retorno - Quantidade de pessoas encontradas.
            if let totalItens = snapshotResultado?.count {
                // Se retornar 0, é porque não há usuário cadastrado.
                if totalItens == 0 {
                    self.delegate?.alertStateError(titulo: "Usuário não Cadastrado.", message: "Verifique o email e tente novamente.")
                    return
                }
            }
            // Salvar contato se passar pela Validação de cima.
            if let snapshot = snapshotResultado {
                for document in snapshot.documents {
                    let dados = document.data() // Irá retornar um Array de Strings.
                    self.salvarContato(dadosContato: dados, idUsuario: idUsuario)
                }
            }
        }
    }
    
    func salvarContato(dadosContato: Dictionary<String, Any>, idUsuario: String) {
        
        // Acessando a Model "Contact".
        let contact: Contact = Contact(dicionario: dadosContato)
        let firestore: Firestore = Firestore.firestore()
        firestore.collection("usuarios").document(idUsuario).collection("contatos").document(contact.id ?? "").setData(dadosContato) { (error) in
            if error == nil {
                self.delegate?.successContato()
            }
        }
    }
}
