//
//  CarbRatioCell.swift
//  Diabestie
//
//  Created by Anika Morris on 10/14/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CarbRatioCell: UITableViewCell {
    
    // MARK: Properties
    static let identifier: String = "CarbRatioCell"
    var time: String!
    var ratio: String!
    
    // MARK: Views
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 18.0)
        return label
    }()
    let ratioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: Constants.fontName, size: 18.0)
        return label
    }()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryColor
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    fileprivate func setUpViews() {
        self.backgroundColor = .backgroundColor
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview()
        }
        containerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        containerView.addSubview(ratioLabel)
        ratioLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    func setLabelText() {
        timeLabel.text = time
        ratioLabel.text = ratio
    }
}
