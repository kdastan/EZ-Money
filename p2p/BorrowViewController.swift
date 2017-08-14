//
//  BorrowViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import RESideMenu
import Firebase
import SVProgressHUD
import NotificationBannerSwift
import HMSegmentedControl
import EasyPeasy
import BetterSegmentedControl

class BorrowViewController: UIViewController {

    var isInvestor = false
    var indexCounter = 0
    
    lazy var vc1: TakeBorrowViewController = {
        let vc1 = TakeBorrowViewController()
        return vc1
    }()
    
    lazy var vc2: RequestListViewController = {
        let vc2 = RequestListViewController()
        return vc2
    }()
    
    lazy var vc3: LendViewController = {
        let vc3 = LendViewController()
        return vc3
    }()
    
    lazy var control: BetterSegmentedControl = {
        let control = BetterSegmentedControl()
        
        control.titleFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        control.selectedTitleFont = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
        control.backgroundColor = .blueBackground
        control.layer.cornerRadius = 4
        control.cornerRadius = 4
        control.indicatorViewBackgroundColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        control.addTarget(self, action: #selector(pressed(sender:)), for: .valueChanged)
        control.bouncesOnChange = true
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueBackground
        
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        navigationItem.titleView = control
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(push))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        isInvestor = appDelegate.isInvestor
        
        if isInvestor {
            addChildViewController(vc3)
            view.addSubview(vc3.view)
            vc1.didMove(toParentViewController: self)
            control.titles = ["Инвестировать", "Список запросов"]
        } else {
            addChildViewController(vc1)
            view.addSubview(vc1.view)
            vc1.didMove(toParentViewController: self)
            control.titles = ["Получить займ", "Список запросов"]
        }
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(sender:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        setupViews()
        setupConstraints()
    }
    
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        indexCounter += 1
        indexCounter = indexCounter % 2
        do {
            try control.setIndex(UInt(indexCounter), animated: true)
        } catch  {
            
        }
    }
    
    func swipeRight(sender: UISwipeGestureRecognizer) {
        indexCounter -= 1
        indexCounter = indexCounter % 2
        if indexCounter < 0 { indexCounter += 2 }
        do {
            try control.setIndex(UInt(indexCounter), animated: true)
        } catch  {
            
        }
    }
    
    
    func setupViews() {
        edgesForExtendedLayout = []
        //view.addSubview(control)
    }
    
    func switcher(from: UIViewController, to: UIViewController) {
        from.willMove(toParentViewController: nil)
        from.view.removeFromSuperview()
        from.removeFromParentViewController()
        
        addChildViewController(vc1)
        view.addSubview(to.view)
        to.didMove(toParentViewController: self)
    }
    
    func pressed(sender: BetterSegmentedControl) {
        if isInvestor {
            switch sender.index{
                case 0:
                    switcher(from: vc2, to: vc3)
                case 1:
                switcher(from: vc3, to: vc2)
                default:
                    print("error")
            }
        } else {
            switch sender.index{
                case 0:
                    switcher(from: vc2, to: vc1)
                case 1:
                    switcher(from: vc1, to: vc2)
                default:
                    print("error")
            }
        
        }

    }
    
    func setupConstraints() {
        control <- [
            CenterY(0),
            CenterX(0),
            Height(30),
            Width(Screen.width - 50)
        ]
    }
    
    func push() {
        sideMenuViewController?.presentLeftMenuViewController()
    }
  
    
}
