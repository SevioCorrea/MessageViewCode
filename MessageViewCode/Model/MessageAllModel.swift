//
//  MessageAllModel.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 26/02/23.
//

import Foundation

// Não é recomendado apenas um File para todos os Models. Está sendo feito pois são muito curtos.

class Message {
    
    var texto: String?
    var idUsuario: String?
    
    init(dicionario: [String: Any]) {
        self.texto = dicionario["texto"] as? String
        self.idUsuario = dicionario["idUsuario"] as? String
    }
}

class Conversation {
    var nome: String?
    var ultimaMensagem: String?
    var idDestinatario: String?
    
    init(dicionario: [String: Any]) {
        self.nome = dicionario["nomeUsuario"] as? String
        self.ultimaMensagem = dicionario["ultimaMensagem"] as? String
        self.idDestinatario = dicionario["idDestinatario"] as? String
    }
}

class User {
    var nome: String?
    var email: String?
    
    init(dicionario: [String: Any]) {
        self.nome = dicionario["nome"] as? String
        self.email = dicionario["email"] as? String
    }
}

class Contact {
    var id: String?
    var nome: String?
    
    init(dicionario: [String: Any]?) {
        self.nome = dicionario?["nome"] as? String
        self.id = dicionario?["id"] as? String
    }
    
    convenience init(id: String?, nome: String?) {
        self.init(dicionario: nil)
        self.id = id
        self.nome = nome
    }
}
