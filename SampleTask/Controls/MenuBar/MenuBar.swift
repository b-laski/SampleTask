//
//  MenuBar.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

protocol MenuBarDelegate: class {
    func cellDidSelect(tabelName: String)
}

struct MenuBarViewItemAttribute {
    var color: UIColor
    var text: String
}

class MenuBarView: UICollectionView {
    
    // MARK: - Public variables -
    var selectedItem: MenuBarViewItemAttribute?
    var firstElemenetShouldBeSelected: Bool = false
    
    weak var menuBarDelegate: MenuBarDelegate?
    
    // MARK: - Inits -
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        
        register(MenuBarCell.self, forCellWithReuseIdentifier: MenuBarCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods -
    
}

extension MenuBarView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(3), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
