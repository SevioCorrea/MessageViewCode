//
//  MessageLastCollectionViewCell.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 28/02/23.
//

import UIKit

class MessageLastCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MessageLastCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = false
        image.image = UIImage(systemName: "person.badge.plus")
        
        return image
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Adicionar novo contato"
        label.font = UIFont(name: CustomFont.poppinsMedium, size: 15)
        label.textColor = .darkGray
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
            
            self.label.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 15),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
