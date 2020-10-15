//
//  CalculatorController.swift
//  Diabestie
//
//  Created by Anika Morris on 10/13/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Motion

class CalculatorController: UIViewController {
    
    // MARK: Properties
    var coordinator: TabBarCoordinator!
    let question = Question(insulinDuration: 3)
    var allQuestions: [String]!
    
    // MARK: Views
    let questionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    let anyCorrectionsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .primaryColor
        return view
    }()
    let eatingNowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .primaryColor
        return view
    }()
    let anyCorrectionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let eatingNowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Yes", "No"])
        control.backgroundColor = UIColor(red: 1, green: 0.7411764706, blue: 0.6745098039, alpha: 1)
        control.selectedSegmentTintColor = .alertColor
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont(name: Constants.fontName, size: 20.0)!]
        control.setTitleTextAttributes(attributes, for: .normal)
        control.addTarget(self, action: #selector(selectedSegmentedDidChange), for: .valueChanged)
        return control
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let rightArrow = UIImage(systemName: "arrow.right", withConfiguration: largeConfig)
        button.setImage(rightArrow, for: .normal)
        button.tintColor = .primaryColor
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    let backButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let leftArrow = UIImage(systemName: "arrow.left", withConfiguration: largeConfig)
        button.setImage(leftArrow, for: .normal)
        button.tintColor = .primaryColor
        return button
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        allQuestions = question.allQuestions()
        setUpInitialView()
    }
    
    // MARK: Methods
    func setUpInitialView() {
        view.backgroundColor = .backgroundColor
        anyCorrectionsLabel.text = allQuestions[0]
        view.addSubview(questionContainer)
        questionContainer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        questionContainer.addSubview(anyCorrectionsView)
        anyCorrectionsView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        anyCorrectionsView.addSubview(anyCorrectionsLabel)
        anyCorrectionsLabel.snp.makeConstraints { (make) in
            make.center.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        questionContainer.addSubview(eatingNowView)
        eatingNowView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionContainer.snp_bottomMargin).offset(30)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp_bottomMargin).offset(view.bounds.height * 0.1)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        buttonStackView.addArrangedSubview(backButton)
        buttonStackView.addArrangedSubview(nextButton)
        nextButton.isHidden = true
        backButton.isHidden = true
        eatingNowView.isHidden = true
    }
    
    fileprivate func animateFadeOut(_ animatedView: UIView) {
        animatedView.animate([.duration(0.2),
                              .fadeOut,
                              .background(color: .clear)
                            ])
    }
    
    fileprivate func animateDropIn(_ animatedView: UIView) {
        let x = view.bounds.width * 0.5
        animatedView.animate([.delay(0.2),
                              .duration(0.01),
                              .position(CGPoint(x: x, y: 0)),
                              .timingFunction(.deceleration)
                            ], completion: {
                                animatedView.isHidden = false
                                animatedView.animate([.duration(0.2),
                                                     .translate(x: 0, y: -200, z: 1),
                                                     .timingFunction(.deceleration)
                                                    ])
                            })
    }
    
    @objc func selectedSegmentedDidChange() {
        nextButton.isHidden = false
    }
    
    @objc func nextButtonTapped() {
        segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        animateFadeOut(anyCorrectionsView)
        animateFadeOut(anyCorrectionsLabel)
        animateDropIn(eatingNowView)
        backButton.isHidden = false
    }
}
