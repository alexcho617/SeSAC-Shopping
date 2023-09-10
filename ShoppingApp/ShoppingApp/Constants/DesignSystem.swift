//
//  DesignSystem.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit

struct DesignSystem{
    static let collectionViewItemWidth = (UIScreen.main.bounds.width - 24) / 2
    static var collectionViewItemHeight: CGFloat{
        return collectionViewItemWidth * 1.5
    }
    static let defaultPadding: CGFloat = 8
    static let cellSize = CGSize(width: 100, height: 100)
}
