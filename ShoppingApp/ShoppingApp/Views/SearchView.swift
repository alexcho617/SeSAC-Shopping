//
//  SearchView.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit
import SnapKit

final class SearchView: BaseView{
    
    let placeholderLabel = {
        let view = UILabel()
        view.text = "상품을 검색하세요"
        view.textColor = .secondaryLabel
        view.font = .boldSystemFont(ofSize: 18)
        view.textAlignment = .center
        return view
    }()
    
    let searchBar = {
        let view = UISearchBar()
        view.showsCancelButton = true
        return view
    }()
    
    let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = DesignSystem.defaultPadding
        layout.minimumInteritemSpacing = DesignSystem.defaultPadding
        layout.itemSize = CGSize(width: DesignSystem.collectionViewItemWidth, height: DesignSystem.collectionViewItemHeight)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier:HeaderCollectionReusableView.id)
        return view
    }()
    
    override func setView() {
        super.setView()
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(placeholderLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DesignSystem.defaultPadding)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(DesignSystem.defaultPadding)
        }
    }
}
