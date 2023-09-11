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
    private let formatter = NumberFormatter()
    private let searchBar = {
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
        likeTable = ItemRealmRepository.shared.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func setView() {
        super.setView()
        title = "좋아요"
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
    }
    
    override func setConstraints() {
        super.setConstraints()
        searchBar.snp.makeConstraints { make in
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
        let processor = DownsamplingImageProcessor(size: DesignSystem.cellSize)
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(
            with: URL(string: data.image),
            placeholder: UIImage(named: "photo"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        cell.seller.text = "[\(data.mallName)]"
        cell.title.text = data.title.removingHTMLTags()
        cell.price.text = formatter.string(from: Double(data.lprice)! as NSNumber)
        cell.productid = data.productId
        cell.like.setImage(ItemRealmRepository.shared.checkProductExistsInRealmByProductId(data.productId) ? UIImage(systemName: "heart.fill"): UIImage(systemName: "heart") , for: .normal)
        cell.disableLike = { productId in
            ItemRealmRepository.shared.delete(targetProductId: productId)
            collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath.row)
        let item = likeTable[indexPath.row]
        let vc = DetailViewController()
        vc.title = item.title.removingHTMLTags()
        vc.id = item.productId
        vc.urlString = NaverAPIManager.shared.linkUrl+item.productId
        vc.item = Item(title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName, productId: item.productId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
