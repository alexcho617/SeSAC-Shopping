//
//  LikeViewController.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/08.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift
class LikeViewController: BaseViewController {
    var likeTable: Results<RealmItem>!

//    let titleLabel = {
//        let view = UILabel()
//        view.text = ViewTitles.likes.rawValue
//        view.font = .boldSystemFont(ofSize: 18)
//        view.textAlignment = .center
//        return view
//    }()
    
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
        view.register(LikeCollectionViewCell.self, forCellWithReuseIdentifier: "likeCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "좋아요 목록"
        
        //TODO: 기본 정렬에서 reverse만 시키면 될듯
        likeTable = ItemRealmRepository.shared.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        collectionView.reloadData()
    }
    override func setView() {
        super.setView()
        title = "좋아요"
//        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        
    }
    override func setConstraints() {
        super.setConstraints()
//        titleLabel.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//        }
        
        searchBar.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(DesignSystem.defaultPadding)
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(DesignSystem.defaultPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    
}

extension LikeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text != nil) && searchBar.text != ""{
            likeTable = ItemRealmRepository.shared.filteredFetch(with: searchBar.text!)
        }else{
            likeTable = ItemRealmRepository.shared.fetch()
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != nil) && searchBar.text != ""{
            likeTable = ItemRealmRepository.shared.filteredFetch(with: searchBar.text!)
        }else{
            likeTable = ItemRealmRepository.shared.fetch()
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        likeTable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likeCell", for: indexPath) as! LikeCollectionViewCell
        let data = likeTable[indexPath.row]
        cell.image.kf.setImage(with: URL(string: data.image))
        cell.seller.text = "[\(data.mallName)]"
        cell.title.text = data.title.removingHTMLTags()
        cell.price.text = data.lprice
        cell.productid = data.productId
        if ItemRealmRepository.shared.checkProductExistsInRealmByProductId(data.productId) == true{
            cell.like.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            cell.like.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.disableLike = { productId in
            ItemRealmRepository.shared.delete(data, target: productId)
            collectionView.reloadData()
        }
        return cell
    }
    
    //TODO: Detail 화면
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath.row)
        let item = likeTable[indexPath.row]
        let vc = DetailViewController()
        vc.title = item.title.removingHTMLTags()
        vc.id = item.productId
        vc.urlString = NaverAPIManager.shared.linkUrl+item.productId
        navigationController?.pushViewController(vc, animated: true)
    }
}
