//
//  FormInputView.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

class FormInputView: UIView {
    
    // MARK: - Components -
    let nameLabel: UILabel = UILabel.light12
    
    let dateTextField: QDateTextField = {
        let textField = QDateTextField()
        textField.layer.borderWidth = Layers.dateTextFieldBorderWidth
        textField.layer.borderColor = Layers.dateTextFieldBorderColor
        return textField
    }()
    
    // MARK: - Inits -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods -
    private func doLayout() {
        addSubview(nameLabel)
        addSubview(dateTextField)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelConstraint = [nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                   nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.nameLabelLeftMargin),
                                   nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)]
        
        NSLayoutConstraint.activate(nameLabelConstraint)
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        let dateTextFieldConstraint = [dateTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constraints.dateTextFieldTopMargin),
                                       dateTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.dateTextFieldLeftMargin),
                                       dateTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
                                       dateTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate(dateTextFieldConstraint)
    }
}

// MARK: - Static values -
private extension FormInputView {
    struct Constraints {
        static let nameLabelLeftMargin: CGFloat = 8
        
        static let dateTextFieldTopMargin: CGFloat = 8
        static let dateTextFieldLeftMargin: CGFloat = 8
    }
    
    struct Layers {
        static let dateTextFieldBorderWidth: CGFloat = 0.5
        static let dateTextFieldBorderColor: CGColor = UIColor.systemOrange.cgColor
    }
}
