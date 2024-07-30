//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by 이찬호 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private let simplePickerView = UIPickerView()
    private let simpleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupPickerView()
    }
    
    private func configureView() {
        view.backgroundColor = .white 
        
        view.addSubview(simplePickerView)
        view.addSubview(simpleLabel)
        
        simplePickerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        simpleLabel.snp.makeConstraints {
            $0.top.equalTo(simplePickerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            
        }
    }
    
    private func setupPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        items.bind(to: simplePickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }


}

