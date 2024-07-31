//
//  AddingNumberViewController.swift
//  RxSwiftPractice
//
//  Created by 이찬호 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddingNumberViewController: UIViewController {
    
    private let textField1 = UITextField()
    private let textField2 = UITextField()
    private let textField3 = UITextField()
    private let resultLabel = UILabel()
        
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBind()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(textField3)
        view.addSubview(resultLabel)
        
        textField1.borderStyle = .roundedRect
        textField2.borderStyle = .roundedRect
        textField3.borderStyle = .roundedRect
        
        textField2.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        textField1.snp.makeConstraints {
            $0.centerX.size.equalTo(textField2)
            $0.bottom.equalTo(textField2.snp.top).offset(-8)
        }
        
        textField3.snp.makeConstraints {
            $0.centerX.size.equalTo(textField2)
            $0.top.equalTo(textField2.snp.bottom).offset(8)
        }
        
        resultLabel.snp.makeConstraints {
            $0.centerX.size.equalTo(textField2)
            $0.top.equalTo(textField3.snp.bottom).offset(8)
        }
    }
    
    private func configureBind() {
        Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty, textField3.rx.text.orEmpty) { value1, value2, value3 -> Int in
                return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
            }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
