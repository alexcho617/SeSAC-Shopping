//
//  DetailViewController.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/09.
//

import UIKit
import WebKit
import SnapKit

class DetailViewController: BaseViewController, WKUIDelegate{
    var urlString: String?
    var id: String?
    
    private let webView = {
        let view = WKWebView()
        return view
    }()
    //TODO:Navigationbar appearance 잡기 초
    override func viewDidLoad() {
        super.viewDidLoad()
        //Scroll 할때 컨텐츠를 최대한 보여주기 위해 (웹툰 같은 경우) 네비게이션 바와 탭바를 숨기는 기능도 구현 가능함
        navigationController?.hidesBarsOnSwipe = true
        let myURL = URL(string:urlString ?? "www.naver.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func setView() {
        super.setView()
        view.addSubview(webView)
    }
    override func setConstraints() {
        super.setConstraints()
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

