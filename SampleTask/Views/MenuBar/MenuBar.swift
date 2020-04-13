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
    var items: [MenuBarViewItemAttribute] = []
    var selectedItem: MenuBarViewItemAttribute?
    var firstElemenetShouldBeSelected: Bool = false
    
    weak var menuBarDelegate: MenuBarDelegate?
    
    // MARK: - Inits -
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        register(MenuBarCell.self, forCellWithReuseIdentifier: MenuBarCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods -
    func setItems(items: [MenuBarViewItemAttribute]) {
        self.items = items
        reloadData()
    }
}

extension MenuBarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuBarCell.identifier, for: indexPath) as! MenuBarCell
        cell.prepareForReuse()
        
        if firstElemenetShouldBeSelected == true && indexPath.item == 0 {
            cell.isSelected = true
            selectItem(at: indexPath, animated: true, scrollPosition: [])
            selectedItem = items[indexPath.item]
            menuBarDelegate?.cellDidSelect(tabelName: items[indexPath.item].text)
        }
        
        cell.textLabel.text = items[indexPath.item].text
        cell.backgroundColor = items[indexPath.item].color
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuBarDelegate?.cellDidSelect(tabelName: items[indexPath.item].text)
        print(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(items.count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
