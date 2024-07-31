//
//  SimpleValidationViewController.swift
//  RxSwiftPractice
//
//  Created by 이찬호 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: UIViewController {
    
    private let nameLabel = UILabel()
    private let passwordLabel = UILabel()
    private let nameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let nameValidLabel = UILabel()
    private let passwordValidLabel = UILabel()
    private let checkButton = UIButton()
        
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBind()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        nameLabel.text = "Username"
        passwordLabel.text = "Password"
        nameTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        nameValidLabel.textColor = .systemRed
        passwordValidLabel.textColor = .systemRed
        
        checkButton.backgroundColor = .systemBlue
        checkButton.setTitle("Do Somthing", for: .normal)
        
        view.addSubview(nameLabel)
        view.addSubview(passwordLabel)
        view.addSubview(nameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nameValidLabel)
        view.addSubview(passwordValidLabel)
        view.addSubview(checkButton)
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        nameValidLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(nameTextField)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(nameValidLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
                }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(nameTextField)
        }
        
        passwordValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(nameTextField)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(passwordValidLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(nameTextField)
            $0.height.equalTo(50)
        }
    }
    
    private func configureBind() {
        nameTextField.rx.text.orEmpty
            .map { $0.count > 5 }
            .bind(with: self) { owner, validation in
                self.nameValidLabel.rx.text.onNext(validation ? "" : "이름은 5글자 이상 입력해주세요")
                self.checkButton.rx.isEnabled.onNext(validation)
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .map { $0.count > 5 }
            .bind(with: self) { owner, validation in
                self.passwordValidLabel.rx.text.onNext(validation ? "" : "비밀번호는 5글자 이상 입력해주세요")
                self.checkButton.rx.isEnabled.onNext(validation)
            }
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.showAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

