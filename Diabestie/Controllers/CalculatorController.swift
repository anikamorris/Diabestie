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
        label.textColor = .darkGray
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let eatingNowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
//    let segmentedControl: UISegmentedControl = {
//        let control = UISegmentedControl()
//        control.setTitle("Yes", forSegmentAt: 0)
//        control.setTitle("No", forSegmentAt: 1)
//        control.tintColor = .secondaryColor
//        return control
//    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        anyCorrectionsLabel.text = questions.anyCorrections
        setUpInitialView()
    }
    
    // MARK: Methods
    func setUpInitialView() {
        view.addSubview(anyCorrectionsView)
        anyCorrectionsView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        anyCorrectionsView.addSubview(anyCorrectionsLabel)
        anyCorrectionsLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview()
        }
//        view.addSubview(segmentedControl)
//        segmentedControl.snp.makeConstraints { (make) in
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(60)
//            make.height.equalToSuperview().multipliedBy(0.1)
//            make.width.equalToSuperview().multipliedBy(0.7)
//        }
    }
}
