//
//  MainCell.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit
import RxDataSources

struct MainData {
    var header: String
    var items: [Item]
}

extension MainData: SectionModelType {
  typealias Item = Table

   init(original: MainData, items: [Item]) {
    self = original
    self.items = items
  }
}

class MainCell: UICollectionViewCell {
    
    // MARK: - Components -
    let currencyNameLabel: UILabel = UILabel.bold21
    let dateLabel: UILabel = UILabel.light12
    let averagePriceLabel: UILabel = UILabel.regular18
    
    // MARK: - Public variables -
    static var identifier: String {
        return String(describing: self)
    }
    
    var currency: Currency? {
        didSet {
            currencyNameLabel.text = currency?.currency
            
            if let averagePrive = currency?.mid {
                averagePriceLabel.text = averagePrive.description
            } else if let averagePrive = currency?.average() {
                averagePriceLabel.text = averagePrive.description
            } else {
                averagePriceLabel.text = "Średnia cena nieznana"
            }
            
        }
    }
    
    var effectiveDate: String? {
        didSet {
            dateLabel.text = effectiveDate
        }
    }
    
    // MARK: - Inits -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods -
    override func prepareForReuse() {
        super.prepareForReuse()
        currencyNameLabel.text = ""
        dateLabel.text = ""
        averagePriceLabel.text = ""
    }
    
    // MARK: - Private methods-
    func doLayout() {
        addSubview(currencyNameLabel)
        addSubview(dateLabel)
        addSubview(averagePriceLabel)
        
        let currencyNameLabelConstraints = [currencyNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constraints.currencyNameLabelTopMargin),
                                            currencyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.currencyNameLabelLeftMargin),
                                            currencyNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.currencyNameLabelRightMargin),
                                            currencyNameLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor)]
        
        NSLayoutConstraint.activate(currencyNameLabelConstraints)
        
        let dateLabelConstraints = [dateLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor),
                                    dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.dateLabelLeftMargin),
                                    dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.dateLabelRightMargin),
                                    dateLabel.bottomAnchor.constraint(equalTo: averagePriceLabel.topAnchor)]
        
        NSLayoutConstraint.activate(dateLabelConstraints)
        
        let averagePriceLabelConstraints = [averagePriceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
                                            averagePriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.averagePriceLabelLeftMargin),
                                            averagePriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.averagePriceLabelRightMargin),
                                            averagePriceLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: Constraints.averagePriceLabelBottomMargin)]
        
        NSLayoutConstraint.activate(averagePriceLabelConstraints)
    }
}

// MARK: - Static values -
private extension MainCell {
    struct Constraints {
        
        static let currencyNameLabelTopMargin: CGFloat = 8
        static let currencyNameLabelLeftMargin: CGFloat = 20
        static let currencyNameLabelRightMargin: CGFloat = -20
        
        static let dateLabelLeftMargin: CGFloat = 20
        static let dateLabelRightMargin: CGFloat = -20
        
        static let averagePriceLabelLeftMargin: CGFloat = 20
        static let averagePriceLabelRightMargin: CGFloat = -20
        static let averagePriceLabelBottomMargin: CGFloat = 8
    }
}
