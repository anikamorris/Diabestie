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
    let closeButton: CloseButton = {
        let button = CloseButton(frame: .zero, title: "X")
        button.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
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
        self.backgroundColor = .backgroundColor
        self.backgroundColor?.withAlphaComponent(0.1)
        self.addSubview(termsOfServiceLabel)
        termsOfServiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        self.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(termsOfServiceLabel.snp_centerYWithinMargins)
            $0.width.height.equalTo(25)
            $0.trailing.equalToSuperview().offset(-15)
        }
        self.addSubview(termsAndConditionsTextView)
        termsAndConditionsTextView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(termsOfServiceLabel.snp_bottomMargin).offset(5)
            $0.height.equalToSuperview().multipliedBy(0.85)
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    //MARK: Helpers
    @objc private func closePopup() {
        self.removeFromSuperview()
    }
}
