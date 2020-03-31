//
//  ViewController.swift
//  RxSwift-Testing
//
//  Created by Zafar on 3/29/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindButtonActions()
        bindButtonState()
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel = ViewModel()
    
    lazy var stackOfButtons: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.addArrangedSubview(firstButton)
        stack.addArrangedSubview(secondButton)
        stack.addArrangedSubview(thirdButton)
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var firstButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("First", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    lazy var secondButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Second", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.red.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    lazy var thirdButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Third", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.purple.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        return button
    }()

}

// MARK: - Binding
extension ViewController {
    private func bindButtonActions() {
        firstButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.didSelectSecond.accept(false)
                self.viewModel.didSelectThird.accept(false)
                self.viewModel
                    .didSelectFirst
                    .accept(!self.viewModel.didSelectFirst.value)
            })
            .disposed(by: disposeBag)
        
        secondButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.didSelectFirst.accept(false)
                self.viewModel.didSelectThird.accept(false)
                self.viewModel
                    .didSelectSecond
                    .accept(!self.viewModel.didSelectSecond.value)
            })
            .disposed(by: disposeBag)
        
        thirdButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.didSelectFirst.accept(false)
                self.viewModel.didSelectSecond.accept(false)
                self.viewModel
                    .didSelectThird
                    .accept(!self.viewModel.didSelectThird.value)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButtonState() {
        viewModel.isFirstEnabled
            .subscribe(onNext: { [weak self] (isEnabled) in
                self?.firstButton.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)

        viewModel.isSecondEnabled
            .subscribe(onNext: { [weak self] (isEnabled) in
                self?.secondButton.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)

        viewModel.isThirdEnabled
            .subscribe(onNext: { [weak self] (isEnabled) in
                self?.thirdButton.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension ViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(stackOfButtons)
        
        NSLayoutConstraint.activate([
            stackOfButtons.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            stackOfButtons.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            stackOfButtons.leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor,
                            constant: 20),
            stackOfButtons.trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor,
                            constant: -20),
            stackOfButtons.heightAnchor
                .constraint(equalToConstant: 50)
        ])
    }
}
