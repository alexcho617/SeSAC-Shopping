//
//  SearchView.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit
import SnapKit
final class SearchView: BaseView{
    
    let titleLabel = {
        let view = UILabel()
        view.text = ViewTitles.search.rawValue
        view.textAlignment = .center
        return view
    }()
    
    let searchBar = {
        let view = UISearchBar()
        view.showsCancelButton = true
        return view
    }()
    
    let filterButton1 = {
        let view = UIButton()
        view.setTitle("정확도", for: .normal)
        view.backgroundColor = .systemGray
        return view
    }()
    
    let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = DesignSystem.defaultPadding
        layout.minimumInteritemSpacing = DesignSystem.defaultPadding
        layout.itemSize = CGSize(width: DesignSystem.collectionViewItemWidth, height: DesignSystem.collectionViewItemHeight)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    override func setView() {
        super.setView()
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(filterButton1)
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        filterButton1.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(DesignSystem.defaultPadding)
            make.leading.equalTo(safeAreaLayoutGuide).inset(DesignSystem.defaultPadding)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterButton1.snp.bottom).offset(DesignSystem.defaultPadding)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DesignSystem.defaultPadding)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
