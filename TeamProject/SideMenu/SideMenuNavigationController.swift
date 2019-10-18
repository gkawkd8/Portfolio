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
        
//        sideMenuManager.menuPresentMode = .menuSlideIn
//        sideMenuManager.menuAnimationFadeStrength = 0.3 // 사이드메뉴 외 화면 음영 0 ~ 1
//        sideMenuManager.menuWidth = 200
//        sideMenuManager.menuAnimationTransformScaleFactor = 0.97 // 사이드메뉴 외 화면 크기 조정 0 ~ 1
//        sideMenuManager.menuShadowOpacity = 1
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mySideMenu = self
    }
    
}
