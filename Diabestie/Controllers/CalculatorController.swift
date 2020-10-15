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

class CalculatorController: UIViewController {
    
    // MARK: Properties
    var coordinator: TabBarCoordinator!
    let questions = Question(insulinDuration: 3)
    
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
        return control
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        anyCorrectionsLabel.text = questions.anyCorrections
        setUpInitialView()
    }
    
    // MARK: Methods
    func setUpInitialView() {
        view.addSubview(questionContainer)
        questionContainer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        questionContainer.addSubview(anyCorrectionsView)
        anyCorrectionsView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        anyCorrectionsView.addSubview(anyCorrectionsLabel)
        anyCorrectionsLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview()
        }
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionContainer.snp_bottomMargin).offset(60)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}
