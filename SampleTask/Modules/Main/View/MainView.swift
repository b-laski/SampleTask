//
//  MainView.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    // MARK: - Components -
    let refresher = UIRefreshControl()
    
    let menuBarView: MenuBarView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        
        let menuBar = MenuBarView(frame: .zero, collectionViewLayout: flow)
        menuBar.firstElemenetShouldBeSelected = true
        return menuBar
    }()
    
    let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .systemBackground
        return collectionView
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
        addSubview(menuBarView)
        addSubview(collectionView)
        
        backgroundColor = .systemBackground
        collectionView.refreshControl = refresher
        collectionView.delegate = self
        
        menuBarView.translatesAutoresizingMaskIntoConstraints = false
        let menuBarConstraints = [menuBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                  menuBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                  menuBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                  menuBarView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
                                  menuBarView.heightAnchor.constraint(lessThanOrEqualToConstant: Constraint.menuBarHeight)]
        
        NSLayoutConstraint.activate(menuBarConstraints)
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let collectionViewConstraints = [collectionView.topAnchor.constraint(equalTo: menuBarView.bottomAnchor),
                                         collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                         collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                         collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
}

extension MainView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: Constraint.currencyCellHeight)
    }
}

private extension MainView {
    struct Constraint {
        static let menuBarHeight: CGFloat = 50
        static let currencyCellHeight: CGFloat = 100
    }
}
