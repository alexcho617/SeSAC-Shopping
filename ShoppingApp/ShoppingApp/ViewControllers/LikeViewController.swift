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
    
    let vm = LikeViewModel()
    
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
        view.register(LikeCollectionViewCell.self, forCellWithReuseIdentifier: LikeCollectionViewCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func setView() {
        super.setView()
        title = "좋아요 목록"
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        bindView()

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
    
    private func bindView(){
        vm.likeTable.bind { result in
            self.collectionView.reloadData()
        }
    }
}

extension LikeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text != nil) && searchBar.text != ""{
            vm.likeTable.value = ItemRealmRepository.shared.filteredFetch(with: searchBar.text!)
        }else{
            vm.likeTable.value = ItemRealmRepository.shared.fetch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != nil) && searchBar.text != ""{
            vm.likeTable.value = ItemRealmRepository.shared.filteredFetch(with: searchBar.text!)
        }else{
            vm.likeTable.value = ItemRealmRepository.shared.fetch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.likeTable.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCollectionViewCell.identifier, for: indexPath) as! LikeCollectionViewCell
        let data = vm.likeTable.value[indexPath.row]
        cell.item = data
        cell.bindData()
        cell.disableLike = { productId in
            ItemRealmRepository.shared.delete(targetProductId: productId)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath.row)
        let item = vm.likeTable.value[indexPath.row]
        let vc = DetailViewController()
        vc.title = item.title.removingHTMLTags()
        vc.id = item.productId
        vc.urlString = NaverAPIManager.shared.linkUrl+item.productId
        vc.item = Item(title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName, productId: item.productId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
