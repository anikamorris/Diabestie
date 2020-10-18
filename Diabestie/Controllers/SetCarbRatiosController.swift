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

class SetCarbRatiosController: UIViewController {
    
    // MARK: Properties
    var coordinator: TabBarCoordinator!
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH a"
        return dateFormatter
    }()
    var sliderStartValue: Int = 0 {
        didSet {
            let difference =  sliderEndValue - sliderStartValue
            ratioTextField.text = String(difference)
        }
    }
    var sliderEndValue: Int = 0 {
        didSet {
            let difference = sliderEndValue - sliderStartValue
            ratioTextField.text = String(difference)
        }
    }
    
    // MARK: Views
    let timeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["AM", "PM"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(selectedSegmentDidChange), for: .valueChanged)
        return control
    }()
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
        label.text = ": 1"
        label.textAlignment = .center
        label.textColor = .secondaryColor
        return label
    }()
    let ratioTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.setUnderlineColor(color: .secondaryColor)
        textField.textColor = .secondaryColor
        textField.textAlignment = .center
        textField.font = UIFont(name: Constants.fontName, size: 18.0) // temporary while testing
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
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpCircularSlider()
    }
    
    // MARK: Methods
    func setUpView() {
        view.backgroundColor = .alertColor
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(hyphenLabel)
        timeStackView.addArrangedSubview(endTimeLabel)
        ratioStackView.addArrangedSubview(ratioTextField)
        ratioTextField.snp.makeConstraints { (make) in
            make.width.equalTo(70)
        }
        ratioStackView.addArrangedSubview(ratioToOneLabel)
        ratioAndLabelStackView.addArrangedSubview(ratioStackView)
        ratioAndLabelStackView.addArrangedSubview(carbRatioLabel)
        view.addSubview(timeSegmentedControl)
        timeSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(40)
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
        view.addSubview(timeStackView)
        timeStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.bottom.equalTo(circularSlider.snp_topMargin).offset(-20)
        }
        view.addSubview(saveRatioButton)
        saveRatioButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    fileprivate func setUpCircularSlider() {
        // set up start and end points
        let halfDayInSeconds = 12 * 60 * 60
        circularSlider.maximumValue = CGFloat(halfDayInSeconds)
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
        print(value)
    }
    
    @objc func selectedSegmentDidChange() {
        // store in military time determined by whether AM or PM is selected
        // future: make colors darker if it's PM
    }
    
    @objc func sliderValueDidChange() {
        print("start")
        adjustValue(value: &circularSlider.startPointValue)
        print("end")
        adjustValue(value: &circularSlider.endPointValue)
        print("----------")
        var startTime = Int(floor(circularSlider.startPointValue / (60 * 60)))
        if startTime == 0 {
            startTime = 12
        }
        let endTime = Int(floor(circularSlider.endPointValue / (60 * 60)))
        if timeSegmentedControl.selectedSegmentIndex == 0 {
            startTimeLabel.text = "\(startTime)AM"
            endTimeLabel.text = "\(endTime)AM"
        } else {
            startTimeLabel.text = "\(startTime)PM"
            endTimeLabel.text = "\(endTime)PM"
        }
    }
    
    @objc func saveRatio() {
        ratioTextField.text = ""
        let difference = sliderEndValue - sliderStartValue
        circularSlider.startPointValue = circularSlider.endPointValue
        circularSlider.endPointValue = CGFloat(sliderEndValue) + CGFloat(difference)
    }
}
