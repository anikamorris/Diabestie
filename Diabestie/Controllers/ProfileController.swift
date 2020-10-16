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
    
    // MARK: Views
    let myStatsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Stats"
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
    var isfStackView: StackViewWithLabelAndTextField!
    var targetBGStackView: StackViewWithLabelAndTextField!
    var insulinDurationStackView: StackViewWithLabelAndTextField!
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
        label.textAlignment = .left
        label.font = UIFont(name: Constants.fontName, size: 24.0)
        return label
    }()
    let editCarbRatiosButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.alertColor, for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    let carbRatioStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    let carbRatioTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
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
        view.addSubview(myStatsLabel)
        myStatsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(60)
        }
        view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(myStatsLabel.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        // constraints for isfStackView
        isfStackView = StackViewWithLabelAndTextField(frame: .zero, label: isfLabel)
        containerStackView.addArrangedSubview(isfStackView)
        isfStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.275)
        }
        // constraints for targetBGStackView
        targetBGStackView = StackViewWithLabelAndTextField(frame: .zero, label: targetBGLabel)
        containerStackView.addArrangedSubview(targetBGStackView)
        targetBGStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.275)
        }
        // constraints for insulinDurationStackView
        insulinDurationStackView = StackViewWithLabelAndTextField(frame: .zero, label: insulinDurationLabel)
        insulinDurationStackView.textField.placeholder = "Hours"
        containerStackView.addArrangedSubview(insulinDurationStackView)
        insulinDurationStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.275)
        }
        view.addSubview(carbRatioStackView)
        carbRatioStackView.snp.makeConstraints { (make) in
            make.top.equalTo(containerStackView.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(50)
        }
        carbRatioStackView.addArrangedSubview(carbRatioLabel)
        carbRatioLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        carbRatioStackView.addArrangedSubview(editCarbRatiosButton)
        editCarbRatiosButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
        }
        view.addSubview(carbRatioTableView)
        carbRatioTableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.top.equalTo(carbRatioLabel.snp_bottomMargin).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    @objc func editButtonTapped() {
        coordinator.goToSetCarbRatiosController(controller: self)
    }
}

extension ProfileController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath.row)")
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
