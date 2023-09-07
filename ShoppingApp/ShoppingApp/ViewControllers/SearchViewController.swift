//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/07.
//

import UIKit

final class SearchViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let searchView = SearchView()
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.searchBar.delegate = self
        searchView.filterButton1.addTarget(self, action: #selector(filterClicked), for: .touchUpInside)
        self.view = searchView
    }
    
    override func setView() {
        super.setView()
        title = ViewTitles.search.rawValue
    }
    
    @objc private func filterClicked(){
        print(#function)
        //1.network call
        //2.reload
    }

}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        searchBar.resignFirstResponder()

    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        
        cell.image.image = UIImage(systemName: "person")
        cell.seller.text = "seller: \(indexPath.row)"
        cell.title.text = "[중고]렉스턴스포츠칸RS 모터홈 <b>캠핑카</b> 5인승 19년식" //<b> 이런거 처리
        cell.price.text = "price: \(indexPath.row)"
        return cell
    }
    
}
