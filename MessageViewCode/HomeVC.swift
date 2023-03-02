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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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
