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
        label.textColor = .darkGray
        label.font = UIFont(name: Constants.fontName, size: 18.0)
        return label
    }()
    let ratioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        label.font = UIFont(name: Constants.fontName, size: 18.0)
        return label
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
        self.contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        self.contentView.addSubview(ratioLabel)
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
