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
    private let simpleSwitch = UISwitch()
    private let signNameTextField = UITextField()
    private let signEmailTextField = UITextField()
    private let signButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupPickerView()
        setupTableView()
        setupSwitch()
        setupSign()
        justTest()
    }
    
    private func configureView() {
        view.backgroundColor = .white 
        
        view.addSubview(simplePickerView)
        view.addSubview(simpleLabel)
        view.addSubview(simpleTableView)
        view.addSubview(simpleSwitch)
        view.addSubview(signNameTextField)
        view.addSubview(signEmailTextField)
        view.addSubview(signButton)
        
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
        
        simpleSwitch.snp.makeConstraints {
            $0.top.equalTo(simpleTableView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        signNameTextField.snp.makeConstraints {
            $0.top.equalTo(simpleSwitch.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        signEmailTextField.snp.makeConstraints {
            $0.top.equalTo(signNameTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        signButton.snp.makeConstraints {
            $0.top.equalTo(signEmailTextField.snp.bottom).offset(8)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
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

    private func setupSwitch() {
        Observable.of(true)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        simpleSwitch.rx.isOn
            .map { "스위치가 \($0) 되었습니다." }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupSign() {
        signNameTextField.placeholder = "이름 입력"
        signEmailTextField.placeholder = "이메일 입력"
        signButton.backgroundColor = .blue

        Observable.combineLatest(signNameTextField.rx.text.orEmpty,
                                 signEmailTextField.rx.text.orEmpty) {
            name, email in
            return "이름은 \(name) 이메일은 \(email)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signNameTextField.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmailTextField.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmailTextField.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "알림!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

}

extension ViewController {
    private func justTest() {
        let itemA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        Observable.just(itemA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just error -\(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
}
