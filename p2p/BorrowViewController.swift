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
import Firebase
import SVProgressHUD

class BorrowViewController: SwipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavbar()
        configureSwiper()
    }
    
    private func setupNavbar() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
        setNavigationWithItem(UIColor.white, leftItem: barButtonItem, rightItem: nil)
    }
    
    private func configureSwiper() {
        
        SVProgressHUD.dismiss()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let app = appDelegate.isInvestor
        
        let VC1 = TakeBorrowViewController()
        VC1.title = "Получить займ"
        
        let VC2 = RequestListViewController()
        VC2.title = "Список запросов"
        
        let VC3 = LendViewController()
        VC3.title = "Инвестировать"
        
        if app {
            setViewControllerArray([VC3, VC2])
            
            print("First")
        } else {
            setViewControllerArray([VC1, VC2])
            print("second")
        }
        //setViewControllerArray([VC3, VC2])
        print("asd")
        
        if Screen.width == 320 {
            setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 15), color: UIColor.black, selectedColor: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
            setSelectionBar(110, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        } else {
            setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 18), color: UIColor.black, selectedColor: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
            setSelectionBar(145, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        }
        setButtonsOffset(35, bottomOffset: 13)
    }
    
    func push() {
        sideMenuViewController?.presentLeftMenuViewController()
    }

}
