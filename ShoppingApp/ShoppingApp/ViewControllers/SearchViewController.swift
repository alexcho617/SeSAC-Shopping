//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit
import Kingfisher
import RealmSwift
final class SearchViewController: BaseViewController {
    private let searchView = SearchView()
    private var didSearch = false
    private var resetFilterFlag = false
    private var isEndOfSearch = false
    private var selectedFilter: SortEnum = .similarity{
        didSet{
            callRequest(searchView.searchBar.text!, sortby: selectedFilter)
            print("DEBUG 2")
        }
    }
    var shop: Shop?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "쇼핑 검색"
        ItemRealmRepository.shared.realmURL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView.collectionView.reloadData()
    }
    
    override func loadView() {
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
//        searchView.collectionView.prefetchDataSource = self
        searchView.searchBar.delegate = self
        self.view = searchView
    }
    
    override func setView() {
        super.setView()
    }
    
    private func callRequest(_ query: String, sortby: SortEnum){
        NaverAPIManager.shared.fetch(query:query , sortby: sortby) { data in
            if self.shop == nil{
                self.shop = data
                self.didSearch = true
                self.searchView.placeholderLabel.isHidden = true
            }else{
                self.shop?.items.append(contentsOf: data.items)
            }
            self.searchView.collectionView.reloadData()

        }
    }
    
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if shop != nil{
            searchView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
        shop = nil
        callRequest(searchBar.text!,sortby: .similarity)
        if selectedFilter != .similarity{
            resetFilterFlag.toggle()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shop = nil
        didSearch = false
        searchView.placeholderLabel.isHidden = false
        searchBar.text = nil
        resetFilterFlag = true
        searchView.collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, // 헤더일때
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: HeaderCollectionReusableView.id,for: indexPath) as? HeaderCollectionReusableView else {return UICollectionReusableView()}
        header.setView()
        header.isHidden = didSearch ? false : true
        if resetFilterFlag == true{
            header.segmentedControl.selectedSegmentIndex = 0
            resetFilterFlag.toggle()
            collectionView.reloadData()
        }
        //closure
        header.segmentControlValueChangedHandler = { [self] filter in
            self.shop = nil
            self.selectedFilter = filter
            print("DEBUG 1")
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shop?.items.count ?? 0
    }
    //TODO: Detail 화면
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(#function, indexPath.row)
        guard let item = shop?.items[indexPath.row] else {return}
        let vc = DetailViewController()
        vc.title = item.title.removingHTMLTags()
        vc.id = item.productId
        vc.urlString = NaverAPIManager.shared.linkUrl+item.productId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        guard let data = shop?.items[indexPath.row] else {return cell}
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
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
//        {
//            result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//            }
//        }
        ///
        
        cell.seller.text = "[\(data.mallName)]"
        cell.title.text = data.title.removingHTMLTags()
        cell.price.text = data.lprice
        cell.item = data
        if ItemRealmRepository.shared.checkProductExistsInRealmByProductId(data.productId) == true{
            //            print("Use FILL", data.productId)
            cell.like.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else if ItemRealmRepository.shared.checkProductExistsInRealmByProductId(data.productId) == false{
            //            print("Use Empty", data.productId)
            cell.like.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        return cell
    }
}
//TODO: Pagenation
//extension SearchViewController: UICollectionViewDataSourcePrefetching{
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//
//    }
//}


//TODO: 가격에 000단위로 쉼표 표기
extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
