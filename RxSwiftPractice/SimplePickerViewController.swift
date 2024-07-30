//
//  SimplePickerViewController.swift
//  RxSwiftPractice
//
//  Created by 이찬호 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimplePickerViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let blackPickerView = UIPickerView()
    private let attributedPickerView = UIPickerView()
    private let colorPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupBlackPickerView()
        setupattributedPickerView()
        setupColorPickerView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(blackPickerView)
        view.addSubview(attributedPickerView)
        view.addSubview(colorPickerView)
        
        blackPickerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        attributedPickerView.snp.makeConstraints {
            $0.top.equalTo(blackPickerView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        colorPickerView.snp.makeConstraints {
            $0.top.equalTo(attributedPickerView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupBlackPickerView() {
        let items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        Observable.just(items)
            .bind(to: blackPickerView.rx.itemTitles) { index, value in
                return String(value)
            }
            .disposed(by: disposeBag)
        
        blackPickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { value in
                print("blackPickerView Selected \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    private func setupattributedPickerView() {
        let items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        Observable.just(items)
            .bind(to: attributedPickerView.rx.itemAttributedTitles) { row, element in
                return NSAttributedString(string: "\(element)",
                                          attributes: [.foregroundColor: UIColor.systemCyan, .underlineStyle: NSUnderlineStyle.single.rawValue])
            }
            .disposed(by: disposeBag)
        
        attributedPickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { value in
                print("blackPickerView Selected \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    private func setupColorPickerView() {
        let items: [UIColor] = [.red, .orange, .yellow, .green, .blue]
        Observable.just(items)
            .bind(to: colorPickerView.rx.items) { row, element, view in
                let colorView = UIView()
                colorView.backgroundColor = element
                return colorView
            }
            .disposed(by: disposeBag)
        
        colorPickerView.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { value in
                print("colorPickerView Selected \(value)")
            })
            .disposed(by: disposeBag)
    }
}
