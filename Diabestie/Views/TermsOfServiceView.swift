//
//  TermsOfServiceView.swift
//  Diabestie
//
//  Created by Anika Morris on 1/7/21.
//  Copyright © 2021 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TermsAndConditionsView: UIView {
    
    //MARK: Properties
    var status: Bool = false
    
    //MARK: Views
    let termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms of Service"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: Constants.fontName, size: 25.0)
        return label
    }()
    let termsAndConditionsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont(name: Constants.fontName, size: 12.0)
        textView.text = Constants.termsAndConditions
        textView.isEditable = false
        textView.backgroundColor = .backgroundColor
        return textView
    }()
    let checkBoxButton: UIButton = {
        let button = UIButton()
        let green = UIColor.systemGreen
        button.layer.cornerRadius = 5
        button.layer.borderColor = green.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(doNotShowAgainChecked), for: .touchUpInside)
        return button
    }()
    
    //MARK: Init
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.addSubview(termsOfServiceLabel)
        termsOfServiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        self.addSubview(termsAndConditionsTextView)
        termsAndConditionsTextView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.8)
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    //MARK: Helpers
    @objc private func doNotShowAgainChecked() {
        if !status {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.showTermsAndConditions)
            checkBoxButton.backgroundColor = .systemGreen
            status = true
        } else {
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.showTermsAndConditions)
            checkBoxButton.backgroundColor = .clear
            status = false
        }
    }
}
