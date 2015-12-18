//
//  Main1ViewController.swift
//  MHImageTabBar
//
//  Created by Mohamed Mohamed on 16/10/15.
//  Copyright © 2015 MHO. All rights reserved.
//

import UIKit
import ActionButton

class Main1ViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    var actionButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let oneImage = UIImage(named: "one.png")!
        let twoImage = UIImage(named: "two.png")!
        
        let oneButton = ActionButtonItem(title: "Action Item 1", image: oneImage)
        oneButton.action = { item in print("Action Item 1...") }
        
        let twoButton = ActionButtonItem(title: "Action Item 2", image: twoImage)
        twoButton.action = { item in print("Action Item 2...") }
        
        actionButton = ActionButton(attachedToView: self.view, items: [oneButton, twoButton])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: .Normal)
        
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            mhTabBarViewController?.setTabBarVisible(true, animated: true)
        } else {
            mhTabBarViewController?.setTabBarVisible(false, animated: true)
        }
    }
}
