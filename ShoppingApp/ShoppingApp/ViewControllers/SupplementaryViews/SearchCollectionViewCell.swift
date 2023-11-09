//
//  SearchCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit
import RealmSwift
import Kingfisher

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    var item: Item!
    
    let image = {
        let view = UIImageView()
        view.backgroundColor = .systemBackground
        view.tintColor = .label
        view.layer.cornerRadius = DesignSystem.defaultPadding
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: "photo") //placeholder
        return view
    }()
    
    let seller = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .secondaryLabel
        view.numberOfLines = 1
        return view
    }()
    
    let title = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.numberOfLines = 2
        return view
    }()
    
    let price = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        view.numberOfLines = 1
        return view
    }()
    
    let like = {
        let view = UIButton()
        view.backgroundColor = .systemBackground
        view.tintColor = .label
        view.layer.cornerRadius = 24
        return view
    }()
    
    @objc private func likeClicked() {
        let realmItem = RealmItem(title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName, productId: item.productId)
        let isLiked = ItemRealmRepository.shared.checkProductExistsInRealmByProductId(realmItem.productId)
        if isLiked {
            ItemRealmRepository.shared.delete(targetProductId: realmItem.productId)
            like.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            ItemRealmRepository.shared.create(realmItem)
            like.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    override func setView() {
        super.setView()
        contentView.addSubview(image)
        contentView.addSubview(seller)
        contentView.addSubview(title)
        contentView.addSubview(price)
        contentView.addSubview(like)
        like.addTarget(self, action: #selector(likeClicked), for: .touchUpInside)
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
        
        like.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.bottom.equalTo(image).inset(DesignSystem.defaultPadding)
        }
    }
    
    func bindData(){
        guard let item = item else {return}
        let processor = DownsamplingImageProcessor(size: DesignSystem.cellSize)
        image.kf.indicatorType = .activity
        image.kf.setImage(
            with: URL(string: item.image),
            placeholder: UIImage(named: "photo"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        seller.text = "[\(item.mallName)]"
        title.text = item.title.removingHTMLTags()
        price.text = item.lprice.currencyFormatted()
        like.setImage(ItemRealmRepository.shared.checkProductExistsInRealmByProductId(item.productId) ? UIImage(systemName: "heart.fill"): UIImage(systemName: "heart") , for: .normal)
    }
}
