//
//  SetCarbRatiosController.swift
//  Diabestie
//
//  Created by Anika Morris on 10/14/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import HGCircularSlider
import SnapKit

// TODO: allow user to update ratios
//      first, check if a particular ratio is already saved
//      if so, rewrite that ratio's ratio to the new carb ratio
//      otherwise, check if the new ratio overlaps with any other ratios
//      if so, either replace the old ratios with the new one and have the user reenter values for the
//      uncovered areas of the old ratios OR keep those ratios and only rewrite the overlap
// TODO: show user which ratios already have values by highlighting covered areas of the slider
// TODO: show the user what their already inputted ratios are in the ratioTextField

class SetCarbRatiosController: UIViewController {
    
    // MARK: Properties
    var coordinator: TabBarCoordinator!
    let carbRatioService = CarbRatioService()
    var allRatios: [CarbRatio] = []
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH a"
        return dateFormatter
    }()
    var startTime: Int = 0
    var endTime: Int = 2
    
    // MARK: Views
    let startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.text = "12AM"
        label.textAlignment = .center
        label.textColor = .secondaryColor
        return label
    }()
    let endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.text = "2AM"
        label.textAlignment = .center
        label.textColor = .secondaryColor
        return label
    }()
    let hyphenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.text = "-"
        label.textAlignment = .center
        label.textColor = .secondaryColor
        return label
    }()
    let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    let circularSlider: RangeCircularSlider = {
        let slider = RangeCircularSlider()
        slider.numberOfRounds = 2
        slider.backgroundColor = .alertColor
        slider.diskColor = .alertColor
        slider.trackFillColor = .primaryColor
        slider.startThumbTintColor = .accentColor
        slider.endThumbTintColor = .accentColor
        slider.lineWidth = 12.0
        slider.backtrackLineWidth = 10.0
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()
    let carbRatioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 18.0)
        label.text = "carb ratio"
        label.textAlignment = .center
        label.textColor = .secondaryColor
        return label
    }()
    let ratioToOneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.text = "1 :"
        label.textAlignment = .center
        label.textColor = .secondaryColor
        return label
    }()
    let ratioTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.setUnderlineColor(color: .secondaryColor)
        textField.textColor = .secondaryColor
        textField.textAlignment = .center
        textField.font = UIFont(name: Constants.fontName, size: 30.0)
        textField.keyboardType = .numberPad
        textField.doneAccessory = true
        return textField
    }()
    let ratioStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    let ratioAndLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    let saveRatioButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Ratio", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 30.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .primaryColor
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveRatio), for: .touchUpInside)
        return button
    }()
    let doneEditingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done Editing", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 20.0)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(saveAllRatios), for: .touchUpInside)
        return button
    }()

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpCircularSlider()
        let hasRatios = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasRatios)
        if hasRatios {
            guard let ratios = carbRatioService.getRatios() else { return }
            allRatios = ratios
        }
    }
    
    // MARK: Methods
    func setUpView() {
        view.backgroundColor = .alertColor
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(hyphenLabel)
        timeStackView.addArrangedSubview(endTimeLabel)
        ratioStackView.addArrangedSubview(ratioToOneLabel)
        ratioStackView.addArrangedSubview(ratioTextField)
        ratioTextField.snp.makeConstraints { (make) in
            make.width.equalTo(70)
        }
        ratioAndLabelStackView.addArrangedSubview(ratioStackView)
        ratioAndLabelStackView.addArrangedSubview(carbRatioLabel)
        view.addSubview(timeStackView)
        timeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        view.addSubview(circularSlider)
        circularSlider.snp.makeConstraints { (make) in
            make.center.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        circularSlider.addSubview(ratioAndLabelStackView)
        ratioAndLabelStackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        view.addSubview(saveRatioButton)
        saveRatioButton.snp.makeConstraints { (make) in
            make.top.equalTo(circularSlider.snp_bottomMargin).offset(30)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        view.addSubview(doneEditingButton)
        doneEditingButton.snp.makeConstraints { (make) in
            make.top.equalTo(saveRatioButton.snp_bottomMargin).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    fileprivate func setUpCircularSlider() {
        // set up start and end points
        let dayInSeconds = 24 * 60 * 60
        circularSlider.maximumValue = CGFloat(dayInSeconds)
        circularSlider.startPointValue = 0
        circularSlider.endPointValue = 2 * 60 * 60
        // set start and end thumb properties
        circularSlider.thumbLineWidth = 5.0
        circularSlider.startThumbStrokeColor = .primaryColor
        circularSlider.startThumbStrokeHighlightedColor = .secondaryColor
        circularSlider.endThumbStrokeColor = .primaryColor
        circularSlider.endThumbStrokeHighlightedColor = .secondaryColor
        // add hours image
        let hoursImage = UIImage(named: "Hours")!
        let hoursImageView = UIImageView(image: hoursImage)
        circularSlider.addSubview(hoursImageView)
        hoursImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        }
        hoursImageView.widthAnchor.constraint(equalTo: hoursImageView.heightAnchor).isActive = true
    }
    
    fileprivate func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
    fileprivate func setTimeLabelsText() {
        setTimeLabel(for: startTimeLabel, with: startTime)
        setTimeLabel(for: endTimeLabel, with: endTime)
    }
    
    fileprivate func setTimeLabel(for label: UILabel, with time: Int) {
        if time == 0  || time == 24 {
            label.text = "12AM"
        } else if time == 12 {
            label.text = "12PM"
        } else if time < 12 {
            label.text = "\(time)AM"
        } else {
            label.text = "\(time % 12)PM"
        }
    }
    
    @objc func selectedSegmentDidChange() {
        setTimeLabelsText()
        // store in military time determined by whether AM or PM is selected
        // future: make colors darker if it's PM
    }
    
    @objc func sliderValueDidChange() {
        adjustValue(value: &circularSlider.startPointValue)
        adjustValue(value: &circularSlider.endPointValue)
        startTime = Int(floor(circularSlider.startPointValue / (60 * 60)))
        endTime = Int(floor(circularSlider.endPointValue / (60 * 60)))
        setTimeLabelsText()
    }
    
    @objc func saveRatio() {
        guard let ratio = ratioTextField.text, let ratioInt = Int(ratio) else {
            self.presentAlert(title: "Please input your carb ratio as a number.")
            return
        }
        var start = startTime
        if start == 24 {
            start = 0
        }
        let carbRatio = CarbRatio(startTime: start, endTime: endTime, ratio: ratioInt)
        allRatios.append(carbRatio)
        ratioTextField.text = ""
    }
    
    @objc func saveAllRatios() {
        carbRatioService.ratios = allRatios
        carbRatioService.saveRatios()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RatiosAdded"), object: nil)
        coordinator.goBackToProfileController(controller: self)
    }
}
