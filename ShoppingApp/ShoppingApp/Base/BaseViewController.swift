//
//  BaseViewController.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    func setView(){
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints(){}
}
