//
//  SimpleTableViewController.swift
//  RxSwiftPractice
//
//  Created by 이찬호 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleTableViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let simpleTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupTableView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(simpleTableView)
        simpleTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SimpleTableViewCell")
        
        let items = (0...19).map { $0 }
        Observable.just(items)
            .bind(to: simpleTableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                cell.accessoryType = .detailButton
                return cell
            }
            .disposed(by: disposeBag)
        simpleTableView.rx.modelSelected(Int.self)
            .map { "Tapped '\($0)'" }
            .subscribe{ value in
                self.showAlert(value)
            }
            .disposed(by: disposeBag)
        
        simpleTableView.rx.itemAccessoryButtonTapped
            .map { "Tapped Detail @ \($0.section), \($0.row)" }
            .subscribe { value in
                self.showAlert(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
