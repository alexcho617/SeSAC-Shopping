//
//  DetailViewController.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/09.
//

import UIKit
import WebKit
import SnapKit

final class DetailViewController: BaseViewController, WKUIDelegate{
    
    var urlString: String?
    var id: String!
    var item: Item? //Network Item을 사용하는 이유는 이 화면에서 좋아요 기능을 위해 RealmItem 인스탄스를 따로 관리하기 때문
    private var isLiked: Bool{
        get{
            return ItemRealmRepository.shared.checkProductExistsInRealmByProductId(id)
        }
    }
    private let webView = {
        let view = WKWebView()
        view.customUserAgent = "NaverShoppingApp_SeSAC"
        return view
    }()
    
    lazy var likeButton = {
        return UIBarButtonItem(image: isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeClicked))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    //네트워크 아이템 기반으로 새로운 RealmItem 인스탄스를 생성하여 디비에 추가 및 삭제
    @objc private func likeClicked() {
        if let item{
            let realmItem = RealmItem(title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName, productId: item.productId)
            
            switch isLiked{
            case true:
                ItemRealmRepository.shared.delete(targetProductId: realmItem.productId)
                likeButton.image = UIImage(systemName: "heart")
            case false:
                ItemRealmRepository.shared.create(realmItem)
                likeButton.image = UIImage(systemName: "heart.fill")
            }
        }
    }

    override func setView() {
        super.setView()
        view.addSubview(webView)
        
        title = item?.title.removingHTMLTags()
        id = item?.productId
        urlString = NaverAPIManager.shared.linkUrl+(item?.productId ?? "")
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.rightBarButtonItem = likeButton
        
        
        let myURL = URL(string:urlString ?? "www.naver.com")
        let myRequest = URLRequest(url: myURL!, timeoutInterval: 5)
        webView.load(myRequest)
    }
    
    override func setConstraints() {
        super.setConstraints()
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

