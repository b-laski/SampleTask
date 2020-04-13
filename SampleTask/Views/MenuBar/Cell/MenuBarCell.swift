//
//  MenuBarCell.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

class MenuBarCell: UICollectionViewCell {
    
    // MARK: - Components -
    let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    // MARK: - Public variables -
    static var identifier: String {
        return String(describing: self)
    }
    
    override var isSelected: Bool {
        willSet {
            underLineView.isHidden = newValue == true ? false : true
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
    
    // MARK: - Lifecycle methods-
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        textLabel.text = ""
        underLineView.isHidden = true
    }

    // MARK: - Private methods -
    private func doLayout() {
        addSubview(textLabel)
        addSubview(underLineView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        let textLabelConstraints = [textLabel.topAnchor.constraint(equalTo: topAnchor),
                                    textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                                    textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                                    textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(textLabelConstraints)
        
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        let underLineViewConstraint = [underLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                       underLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                       underLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                       underLineView.heightAnchor.constraint(equalToConstant: 5)]
        
        NSLayoutConstraint.activate(underLineViewConstraint)
        
    }
}
