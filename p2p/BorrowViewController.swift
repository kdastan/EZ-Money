//
//  BorrowViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwipeViewController

class BorrowViewController: SwipeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let VC1 = TakeBorrowViewController()
        //VC1.view.backgroundColor = UIColor(red: 0.19, green: 0.36, blue: 0.60, alpha: 1.0)
        VC1.title = "Получить займ"
        
        let VC2 = RequestListViewController()
        //VC2.view.backgroundColor = UIColor(red: 0.11, green: 0.26, blue: 0.90, alpha: 1.0)
        VC2.title = "Список запросов"
        
        
        setViewControllerArray([VC1, VC2])
        setFirstViewController(0)
        setSelectionBar(80, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 18), color: UIColor.black, selectedColor: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        equalSpaces = false
        setButtonsOffset(20, bottomOffset: 5)
        setSelectionBar(150, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        
        
    }

}
