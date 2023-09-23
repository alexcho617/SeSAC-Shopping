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
        }
    }
    private var shop: Shop?

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
        searchView.collectionView.prefetchDataSource = self
        searchView.searchBar.delegate = self
        self.view = searchView
    }
    
    
    private func callRequest(_ query: String, sortby: SortEnum){
        NaverAPIManager.shared.fetch(query:query , sortby: sortby) { data in
            switch data {
            case .success(let success):
                if self.shop == nil{
                    self.shop = success
                    self.didSearch = true
                    self.searchView.placeholderLabel.isHidden = true
                }else{
                    self.shop?.items.append(contentsOf: success.items)
                }
                self.searchView.collectionView.reloadData()
            case .failure(let failure):
                print("DEBUG:",failure, failure.errorDescription,failure.localizedDescription)
                self.showAlert(title: "에러", message: failure.errorDescription)
                
            }
        }
    }
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if shop != nil{
            searchView.collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .top, animated: true)
            
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
        guard kind == UICollectionView.elementKindSectionHeader,
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
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shop?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = shop?.items[indexPath.row] else {return}
        let vc = DetailViewController()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        guard let data = shop?.items[indexPath.row] else {return cell}
        cell.item = data
        cell.bindData()
        return cell
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let row = indexPath.row
            guard shop != nil else {return}
            let count = shop!.items.count
            if  count - 1 == row && count < NaverAPIManager.shared.searchLimit {
                print(#function, count)
                callRequest(searchView.searchBar.text!, sortby: selectedFilter)
            }
        }
    }
}

