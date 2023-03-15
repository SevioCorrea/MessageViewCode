//
//  HomeVC.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 22/02/23.
//

import UIKit
import Firebase


class HomeVC: UIViewController {
    
    var auth: Auth?
    var db: Firestore?
    var idUsuarioLogado: String?
    
    var screenContact: Bool?
    var emailUsuarioLogado: String?
    var alert: Alert?
    
    var screen: HomeScreen?
    
    var contato: ContatoController?
    var listContact: [Contact] = []
    var listaConversas: [Conversation] = []
    var conversasListener: ListenerRegistration?

    
    override func loadView() {
        self.screen = HomeScreen()
        self.view = self.screen
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = CustomColor.appLight
        self.configHomeView()
        self.configCollectionView()
        self.configAlert()
        self.configIdentifierFirebase()
        self.configContato()
        self.addListenerRecuperarConversa()
    }
    
    private func configHomeView() {
        self.screen?.navView.delegate(delegate: self)
    }
    
    private func configCollectionView() {
        self.screen?.delegateCollectionView(delegate: self, dataSource: self)
    }
    
    private func configAlert() {
        self.alert = Alert(controller: self)
    }
    
    private func configIdentifierFirebase() {
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
        
        // Recuperar ID do Usuário Logado.
        if let currentUser = auth?.currentUser {
            self.idUsuarioLogado = currentUser.uid
            self.emailUsuarioLogado = currentUser.email
        }
    }
    
    private func configContato() {
        self.contato = ContatoController()
        self.contato?.delegate(delegate: self)
    }
    
    func addListenerRecuperarConversa() {
        if let idUsuarioLogado = auth?.currentUser?.uid {
            self.conversasListener = db?.collection("conversas").document(idUsuarioLogado).collection("ultimas_conversas").addSnapshotListener({ querySnapshot, error in
                if error == nil {
                    self.listaConversas.removeAll()
                    
                    if let snapshot = querySnapshot {
                        for document in snapshot.documents {
                            let dados = document.data()
                            self.listaConversas.append(Conversation(dicionario: dados))
                        }
                        self.screen?.reloadCollectionView()
                    }
                }
            })
        }
    }
    
    func getContato() {
        self.listContact.removeAll()
        self.db?.collection("usuarios").document(self.idUsuarioLogado ?? "").collection("contatos").getDocuments(completion: { snapshotResultado, error in
            if error != nil {
                print("Error getContato")
                return
            }
            
            if let snapshot = snapshotResultado {
                for document in snapshot.documents {
                    let dadosContato = document.data()
                    self.listContact.append(Contact(dicionario: dadosContato))
                }
                self.screen?.reloadCollectionView()
            }
        })
    }
    
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Se estiver na tela de contatos, mostra as células dos contatos + a célula de Adicionar Contato.
        // Verificando em qual tela está. screenContact ou listaConversas.
        if self.screenContact ?? false {
            return self.listContact.count + 1
        } else {
            return self.listaConversas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.screenContact ?? false {
            if indexPath.row == self.listContact.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageLastCollectionViewCell.identifier, for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as! MessageDetailCollectionViewCell
                cell.setUpViewContact(contact: self.listContact[indexPath.row])
                return cell
            }
        } else {
            // Célula de Conversas
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as! MessageDetailCollectionViewCell
            cell.setUpViewChat(chat: self.listaConversas[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.screenContact ?? false {
            if indexPath.row == self.listContact.count {
                self.alert?.addContact(completion: { value in
                    self.contato?.addContact(email: value, emailUsuarioLogado: self.emailUsuarioLogado ?? "", idUsuario: self.idUsuarioLogado ?? "")
                })
            } else {
                
            }
        } else {
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    
}

extension HomeVC: NavViewProtocol {
    
    func typeScreenMessage(type: TypeChatOrContact) {
        
        switch type {
        case .contact:
            self.screenContact = true
            self.getContato()
            self.conversasListener?.remove()
        case .chat:
            self.screenContact = false
            self.addListenerRecuperarConversa()
            self.screen?.reloadCollectionView()
        }
    }
    
}

extension HomeVC: ContatoProtocol {
    
    func alertStateError(titulo: String, message: String) {
        self.alert?.getAlert(titulo: titulo, mensagem: message)
    }
    
    func successContato() {
        self.alert?.getAlert(titulo: "Ok.", mensagem: "Usuário Cadastrado.", completion: {
            self.getContato()
        })
    }
    
    
}
