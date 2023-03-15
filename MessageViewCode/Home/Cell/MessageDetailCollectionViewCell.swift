//
//  MessageDetailCollectionViewCell.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 28/02/23.
//

import UIKit

class MessageDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MessageDetailCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 26
        image.image = UIImage(systemName: "imagem-perfil")
        
        return image
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.label)
        self.setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
        
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 55),
            self.imageView.heightAnchor.constraint(equalToConstant: 55),
            
            self.label.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 15),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViewContact(contact: Contact) {
        self.setUserName(label: contact.nome ?? "")
    }
    
    func setUpViewChat(chat: Conversation) {
        self.setUpNameAttributedText(chat)
    }
    
    func setUpNameAttributedText(_ chat: Conversation) {
        let attributedText = NSMutableAttributedString(string: "\(chat.nome ?? "")" , attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 15) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        

        attributedText.append(NSAttributedString(string:"\n\(chat.ultimaMensagem ?? "")", attributes: [NSAttributedString.Key.font: UIFont(name: CustomFont.poppinsMedium, size: 15) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        self.label.attributedText = attributedText
    }
    
    func setUserName(label: String) {
        if let font = UIFont(name: "Helvetica Neue", size: 15) {
            let attributedText = NSMutableAttributedString(string: label, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            self.label.attributedText = attributedText
        }
//        self.label.font = UIFont.boldSystemFont(ofSize: 15)
//        self.label.tintColor = .black
    }
    
}
