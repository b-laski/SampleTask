//
//  UILabel.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

extension UILabel {
    static private func newInstance(font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.tintColor = .black
        label.font = font
        return label
    }
    
    static var bold21: UILabel {
        return newInstance(font: .boldSystemFont(ofSize: 21))
    }
    
    static var light12: UILabel {
        return newInstance(font: .systemFont(ofSize: 12, weight: .light))
    }
    
    static var regular18: UILabel {
        return newInstance(font: .systemFont(ofSize: 18))
    }
    
}
