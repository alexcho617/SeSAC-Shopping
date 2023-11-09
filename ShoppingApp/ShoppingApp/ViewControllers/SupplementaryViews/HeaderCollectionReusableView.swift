//
//  HeaderCollectionReusableView.swift
//  ShoppingApp
//
//  Created by Alex Cho on 2023/09/08.
//

import UIKit
import SnapKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let id = String(describing: HeaderCollectionReusableView.self)
    var segmentControlValueChangedHandler: ((SortEnum) -> Void)?
    
    lazy var segmentedControl: UISegmentedControl = {
        let array: [String] = ["정확도순", "날짜순", "가격높은순","가격낮은순"]
        let view = UISegmentedControl(items: array)
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentChanged(to:)), for: UIControl.Event.valueChanged)
        return view
    }()
    
    @objc func segmentChanged(to segment: UISegmentedControl) {
        var sort: SortEnum?
        
        switch segment.selectedSegmentIndex{
        case 0: sort = .similarity
        case 1:
            sort = .date
        case 2:
            sort = .descendingPrice
        case 3:
            sort = .ascendingPrice
        default: sort = .similarity
        }
        segmentControlValueChangedHandler?(sort ?? .similarity)
    }
    
    func setView() {
        addSubview(segmentedControl)
    }
    
    func setConstrants(){
        segmentedControl.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.bottom.equalTo(self).inset(8)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstrants()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
