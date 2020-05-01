//
//  MenuBar.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

class MenuBarView: UICollectionView {
    
    // MARK: - Public variables -
    var selectedItem: MenuBarViewItemAttribute?
    var firstElemenetShouldBeSelected: Bool = false
    
    // MARK: - Inits -
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        
        register(MenuBarCell.self, forCellWithReuseIdentifier: MenuBarCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MenuBarView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = collectionView.numberOfItems(inSection: 0)
        return CGSize(width: frame.width / CGFloat(items), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
