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
import RealmSwift

class ProfileController: UIViewController {
    
    // MARK: Properties
    var coordinator: TabBarCoordinator!
    let statsService = StatsService()
    let carbRatioService = CarbRatioService()
    var carbRatios: [CarbRatio] = []
    
    // MARK: Views
    let myStatsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Stats"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        return label
    }()
    let infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(showTermsOfService), for: .touchUpInside)
        return button
    }()
    let isfLabel: UILabel = {
        let label = UILabel()
        label.text = "ISF"
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 20.0)
        return label
    }()
    let targetBGLabel: UILabel = {
        let label = UILabel()
        label.text = "Target BG"
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 20.0)
        return label
    }()
    let insulinDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "Insulin duration"
        label.textColor = .white
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
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .alertColor
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.setTitle("Save Stats", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 25.0)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: NSNotification.Name(rawValue: "RatiosAdded"), object: nil)
        carbRatioTableView.dataSource = self
        carbRatioTableView.delegate = self
        setUpViews()
        setUpServices()
    }
    
    // MARK: Methods
    private func setUpTermsOfServiceView() {
        let termsOfServiceView = TermsAndConditionsView()
        view.addSubview(termsOfServiceView)
        termsOfServiceView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func setUpViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(myStatsLabel)
        myStatsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(60)
        }
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(myStatsLabel.snp_centerYWithinMargins)
            make.height.width.equalTo(20)
            make.trailing.equalToSuperview().offset(-15)
        }
        view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(myStatsLabel.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.3)
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
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(containerStackView.snp_bottomMargin).offset(20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.centerX.equalToSuperview()
        }
        view.addSubview(carbRatioStackView)
        carbRatioStackView.snp.makeConstraints { (make) in
            make.top.equalTo(saveButton.snp_bottomMargin).offset(25)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpServices() {
        let ratioRealm = try! Realm()
        let statsRealm = try! Realm()
        carbRatioService.realm = ratioRealm
        statsService.realm = statsRealm
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasRatios) {
            do {
                let ratios = try carbRatioService.getAllRatios()
                for ratio in ratios {
                    carbRatios.append(ratio)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            carbRatios = []
        }
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSavedStats) {
            let insulinDuration = statsService.getInsulinDuration()
            let isf = statsService.getISF()
            let targetBG = statsService.getTargetBG()
            setStatsTextFields(insulinDuration: insulinDuration, isf: isf, targetBG: targetBG)
        }
    }
    
    private func setStatsTextFields(insulinDuration: Double?, isf: Double?, targetBG: Double?) {
        guard let insulinDuration = insulinDuration, let isf = isf, let targetBG = targetBG else { return }
        isfStackView.textField.text = String(isf)
        targetBGStackView.textField.text = String(targetBG)
        insulinDurationStackView.textField.text = String(insulinDuration)
    }
    
    private func setTime(with time: Int) -> String {
        if time == 0  || time == 24 {
            return "12AM"
        } else if time == 12 {
            return "12PM"
        } else if time < 12 {
            return "\(time)AM"
        } else {
            return "\(time % 12)PM"
        }
    }
    
    @objc func showTermsOfService() {
        setUpTermsOfServiceView()
    }
    
    @objc func isfDoneButtonTapped(textField: UITextField) {
        if textField == isfStackView.textField {
            guard let isf = textField.text else {
                self.presentAlert(title: "Please input your insulin sensitivity factor.")
                return
            }
            if isf == "" {
                self.presentAlert(title: "Please input your insulin sensitivity factor.")
                return
            }
            UserDefaults.standard.setValue(isf, forKey: UserDefaultsKeys.isf)
        } else if textField == targetBGStackView.textField {
            guard let targetBG = textField.text else {
                self.presentAlert(title: "Please input your target blood glucose level.")
                return
            }
            if targetBG == "" {
                self.presentAlert(title: "Please input your target blood glucose level.")
                return
            }
            UserDefaults.standard.setValue(targetBG, forKey: UserDefaultsKeys.targetBG)
        } else if textField == insulinDurationStackView.textField {
            guard let insulinDuration = textField.text else {
                self.presentAlert(title: "Please input your insulin duration in hours.")
                return
            }
            if insulinDuration == "" {
                self.presentAlert(title: "Please input your insulin duration in hours.")
                return
            }
            UserDefaults.standard.setValue(insulinDuration, forKey: UserDefaultsKeys.insulinDuration)
        }
        textField.resignFirstResponder()
    }
    
    @objc func targetBGDoneButtonTapped(sender: UITextField) {
        if sender == targetBGStackView.textField {
            guard let targetBG = sender.text else {
                self.presentAlert(title: "Please input your target blood glucose level.")
                return
            }
            if targetBG == "" {
                self.presentAlert(title: "Please input your target blood glucose level.")
                return
            }
            UserDefaults.standard.setValue(targetBG, forKey: UserDefaultsKeys.targetBG)
        }
    }
    
    @objc func insulinDurationDoneButtonTapped() {
        
    }
    
    @objc func refreshTableView() {
        do {
            let ratios = try carbRatioService.getAllRatios()
            carbRatios = []
            for ratio in ratios {
                carbRatios.append(ratio)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        carbRatioTableView.reloadData()
    }
    
    @objc func editButtonTapped() {
        coordinator.goToSetCarbRatiosController(controller: self)
    }
    
    @objc func saveButtonTapped() {
        guard let isf = isfStackView.textField.text,
              let targetBG = targetBGStackView.textField.text,
              let insulinDuration = insulinDurationStackView.textField.text else {
            self.presentAlert(title: "Please input all stats.")
            return
        }
        if isf == "" || targetBG == "" || insulinDuration == "" {
            self.presentAlert(title: "Please input all stats.")
            return
        }
        let stats = statsService.createStats(Double(insulinDuration)!, Double(isf)!, Double(targetBG)!)
        statsService.saveStats(stats)
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.hasSavedStats)
        self.presentAlert(title: "Stats successfully saved!")
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
        return carbRatios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarbRatioCell.identifier) as! CarbRatioCell
        let carbRatio = carbRatios[indexPath.row]
        let startTime = setTime(with: carbRatio.startTime)
        let endTime = setTime(with: carbRatio.endTime)
        let ratio = carbRatio.ratio
        cell.time = "\(startTime) - \(endTime)"
        cell.ratio = "1:\(ratio)"
        cell.setLabelText()
        return cell
    }
}
