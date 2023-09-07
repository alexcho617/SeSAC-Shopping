//
//  SearchCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    let image = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.image = UIImage(systemName: "photo")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let seller = {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }()
    
    let title = {
        let view = UILabel()
        view.numberOfLines = 2
        return view
    }()
    
    let price = {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }()
    
    override func setView() {
        super.setView()
        contentView.backgroundColor = .systemGray
        contentView.addSubview(image)
        contentView.addSubview(seller)
        contentView.addSubview(title)
        contentView.addSubview(price)

    }
    override func setConstraints() {
         
        super.setConstraints()
        image.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.width)
        }
        
        seller.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(seller.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        price.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
