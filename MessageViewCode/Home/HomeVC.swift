//
//  HomeVC.swift
//  MessageViewCode
//
//  Created by Sévio Basilio Corrêa on 22/02/23.
//

import UIKit

class HomeVC: UIViewController {
    
    var screen: HomeScreen?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func loadView() {
        self.screen = HomeScreen()
        self.view = self.screen
    }

}
