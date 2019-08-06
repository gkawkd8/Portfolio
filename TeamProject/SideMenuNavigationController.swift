//
//  SideMenuNavigationController.swift
//  TeamProject
//
//  Created by 조정현 on 06/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuNavigationController: UISideMenuNavigationController {
    
    let customSideMenuManager = SideMenuManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        sideMenuManager = customSideMenuManager
        sideMenuManager.menuPresentMode = .menuSlideIn
        sideMenuManager.menuWidth = 50
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mySideMenu = self
    }
    
}
