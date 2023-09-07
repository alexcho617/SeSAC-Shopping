//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("search vc")
    }
    
    override func loadView() {
        self.view = mainView()
    }


}

