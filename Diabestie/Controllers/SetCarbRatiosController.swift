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
        dateFormatter.dateFormat = "hh:mm a"
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
    let circularSlider: RangeCircularSlider = {
        let slider = RangeCircularSlider()
        slider.backgroundColor = .alertColor
        slider.diskColor = .alertColor
        slider.trackFillColor = .primaryColor
        slider.startThumbTintColor = .accentColor
        slider.endThumbTintColor = .accentColor
        slider.lineWidth = 12.0
        slider.backtrackLineWidth = 10.0
        let dayInSeconds = 12 * 60 * 60
        slider.maximumValue = CGFloat(dayInSeconds)
        slider.startPointValue = 0
        slider.endPointValue = 2 * 60 * 60
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()
    let timeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["AM", "PM"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(selectedSegmentDidChange), for: .valueChanged)
        return control
    }()
    let carbRatioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 18.0)
        label.text = "Carb Ratio"
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
        textField.font = UIFont(name: Constants.fontName, size: 30.0)
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
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpCircularSlider()
    }
    
    // MARK: Methods
    func setUpView() {
        view.backgroundColor = .alertColor
        ratioStackView.addArrangedSubview(ratioTextField)
        ratioStackView.addArrangedSubview(ratioToOneLabel)
        ratioAndLabelStackView.addArrangedSubview(ratioStackView)
        ratioAndLabelStackView.addArrangedSubview(carbRatioLabel)
        view.addSubview(timeSegmentedControl)
        timeSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(40)
        }
        view.addSubview(circularSlider)
        circularSlider.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.center.equalToSuperview()
        }
        view.addSubview(ratioAndLabelStackView)
        ratioAndLabelStackView.snp.makeConstraints { (make) in
            make.top.equalTo(circularSlider.snp_bottomMargin).offset(30)
            make.width.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    fileprivate func setUpCircularSlider() {
        let hoursImage = UIImage(named: "Hours")!
        let hoursImageView = UIImageView(image: hoursImage)
        circularSlider.addSubview(hoursImageView)
        hoursImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.center.equalToSuperview()
        }
        hoursImageView.widthAnchor.constraint(equalTo: hoursImageView.heightAnchor).isActive = true
    }
    
    @objc func selectedSegmentDidChange() {
        // store in military time determined by whether AM or PM is selected
        // future: make colors darker if it's PM
    }
    
    @objc func sliderValueDidChange() {
        sliderStartValue = Int(circularSlider.startPointValue)
        sliderEndValue = Int(circularSlider.endPointValue)
    }
}
