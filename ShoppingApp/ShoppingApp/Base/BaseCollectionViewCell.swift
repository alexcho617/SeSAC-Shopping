//
//  BaseCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(){}
    func setConstraints(){}
}
