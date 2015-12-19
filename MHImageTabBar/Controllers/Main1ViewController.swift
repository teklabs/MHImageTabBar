//
//  Main1ViewController.swift
//  MHImageTabBar
//
//  Created by Mohamed Mohamed on 16/10/15.
//  Copyright © 2015 MHO. All rights reserved.
//

import UIKit
//import TabBarActionButton

class Main1ViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    var tabBarActionButton: TabBarActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let oneImage = UIImage(named: "one.png")!
        let twoImage = UIImage(named: "two.png")!
        
        let oneButton = TabBarActionButtonItem(title: "Action Item 1", image: oneImage)
        oneButton.action = { item in print("Action Item 1...") }
        
        let twoButton = TabBarActionButtonItem(title: "Action Item 2", image: twoImage)
        twoButton.action = { item in print("Action Item 2...") }
        
        tabBarActionButton = TabBarActionButton(attachedToView: self.view, items: [oneButton, twoButton])
        tabBarActionButton.action = { button in button.toggleMenu() }
        tabBarActionButton.setTitle("+", forState: .Normal)
        
        tabBarActionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        
        //segmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            mhTabBarViewController?.setTabBarVisible(true, animated: true)
        } else {
            mhTabBarViewController?.setTabBarVisible(false, animated: true)
        }
    }
}
