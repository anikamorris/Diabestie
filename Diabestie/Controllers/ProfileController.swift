//
//  ProfileController.swift
//  Diabestie
//
//  Created by Anika Morris on 10/13/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ProfileController: UIViewController {
    
    // MARK: Properties
    var coordinator: TabBarCoordinator!
    let name: String = "Anika"
    
    // MARK: Views
    let helloLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 30.0)
        return label
    }()
    let isfLabel: UILabel = {
        let label = UILabel()
        label.text = "ISF"
        label.textColor = .darkGray
        label.font = UIFont(name: "Futura", size: 20.0)
        return label
    }()
    let targetBGLabel: UILabel = {
        let label = UILabel()
        label.text = "Target BG"
        label.textColor = .darkGray
        label.font = UIFont(name: "Futura", size: 20.0)
        return label
    }()
    let insulinDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "Insulin duration"
        label.textColor = .darkGray
        label.font = UIFont(name: "Futura", size: 20.0)
        return label
    }()
    let isfTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.font = UIFont(name: "Futura", size: 20.0)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.setUnderlineColor(color: .secondaryColor)
        return textField
    }()
    let targetBGTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.font = UIFont(name: "Futura", size: 20.0)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.setUnderlineColor(color: .secondaryColor)
        return textField
    }()
    let insulinDurationTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.font = UIFont(name: "Futura", size: 20.0)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.placeholder = "Hours"
        textField.setUnderlineColor(color: .secondaryColor)
        return textField
    }()
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: Methods
    fileprivate func setUpViews() {
        view.backgroundColor = .backgroundColor
        helloLabel.text = "Hi, \(name)"
        view.addSubview(helloLabel)
        helloLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(60)
        }
        let isfStackView = StackViewWithLabelAndTextField(frame: .zero, label: isfLabel, textField: isfTextField)
        let targetBGStackView = StackViewWithLabelAndTextField(frame: .zero, label: targetBGLabel, textField: targetBGTextField)
        let insulinDurationStackView = StackViewWithLabelAndTextField(frame: .zero, label: insulinDurationLabel, textField: insulinDurationTextField)
        view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(helloLabel.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        containerStackView.addArrangedSubview(isfStackView)
        isfStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.275)
        }
        containerStackView.addArrangedSubview(targetBGStackView)
        targetBGStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.275)
        }
        containerStackView.addArrangedSubview(insulinDurationStackView)
        insulinDurationStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.275)
        }
    }
}
