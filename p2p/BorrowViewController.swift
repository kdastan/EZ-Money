//
//  BorrowViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwipeViewController
import RESideMenu


class BorrowViewController: SwipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sizeX = UIScreen.main.bounds.width

        view.backgroundColor = .white
        
        let VC1 = TakeBorrowViewController()
        VC1.title = "Получить займ"
        
        let VC2 = RequestListViewController()
        VC2.title = "Список запросов"
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
        setNavigationWithItem(UIColor.white, leftItem: barButtonItem, rightItem: nil)
        
        setViewControllerArray([VC1, VC2])
        setFirstViewController(0)
        //setSelectionBar(80, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 18), color: UIColor.black, selectedColor: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        equalSpaces = false
        setButtonsOffset(35, bottomOffset: 10)
        setSelectionBar(150, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        
    }
    
    func push() {
        sideMenuViewController?.presentLeftMenuViewController()
    }

}
