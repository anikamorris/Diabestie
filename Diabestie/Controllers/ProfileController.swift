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
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        return label
    }()
    let isfLabel: UILabel = {
        let label = UILabel()
        label.text = "ISF"
        label.textColor = .darkGray
        label.font = UIFont(name: Constants.fontName, size: 20.0)
        return label
    }()
    let targetBGLabel: UILabel = {
        let label = UILabel()
        label.text = "Target BG"
        label.textColor = .darkGray
        label.font = UIFont(name: Constants.fontName, size: 20.0)
        return label
    }()
    let insulinDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "Insulin duration"
        label.textColor = .darkGray
        label.font = UIFont(name: Constants.fontName, size: 20.0)
        return label
    }()
    let isfTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.font = UIFont(name: Constants.fontName, size: 20.0)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.setUnderlineColor(color: .secondaryColor)
        return textField
    }()
    let targetBGTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.font = UIFont(name: Constants.fontName, size: 20.0)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.setUnderlineColor(color: .secondaryColor)
        return textField
    }()
    let insulinDurationTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.font = UIFont(name: Constants.fontName, size: 20.0)
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
    let carbRatioLabel: UILabel = {
        let label = UILabel()
        label.text = "Carb Ratios"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: Constants.fontName, size: 24.0)
        return label
    }()
    let carbRatioTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CarbRatioCell.self, forCellReuseIdentifier: CarbRatioCell.identifier)
        return tableView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        carbRatioTableView.dataSource = self
        carbRatioTableView.delegate = self
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
        view.addSubview(carbRatioLabel)
        carbRatioLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerStackView.snp_bottomMargin).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        view.addSubview(carbRatioTableView)
        carbRatioTableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.top.equalTo(carbRatioLabel.snp_bottomMargin).offset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

extension ProfileController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ProfileController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarbRatioCell.identifier) as! CarbRatioCell
        cell.time = "12am-2am"
        cell.ratio = "4:1"
        cell.setLabelText()
        return cell
    }
}
