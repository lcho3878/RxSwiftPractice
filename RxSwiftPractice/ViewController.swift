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
    private let simpleTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupPickerView()
        setupTableView()
    }
    
    private func configureView() {
        view.backgroundColor = .white 
        
        view.addSubview(simplePickerView)
        view.addSubview(simpleLabel)
        view.addSubview(simpleTableView)
        
        simplePickerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        simpleLabel.snp.makeConstraints {
            $0.top.equalTo(simplePickerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        simpleTableView.snp.makeConstraints {
            $0.top.equalTo(simpleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(view.safeAreaInsets)
            $0.height.equalTo(100)
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
    
    private func setupTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let items = Observable.just([
            "TableView Item1",
            "TableView Item2",
            "TableView Item3",
            "TableView Item4"
        ])
        items
            .bind(to: simpleTableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { "\($0)을 클릭했습니다." }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }


}

