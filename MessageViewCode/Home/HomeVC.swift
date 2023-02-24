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
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = CustomColor.appLight
    }
    
    
    
    override func loadView() {
        self.screen = HomeScreen()
        self.view = self.screen
    }

}
