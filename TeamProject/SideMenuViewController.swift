//
//  SideMenuViewController.swift
//  TeamProject
//
//  Created by 조정현 on 06/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    

    @IBAction func btnLogout(_ sender: UIButton) {
        // Alert 창 생성
        let logoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        // "네" 클릭 시 실행 액션
        let yesAlert = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: {ACTION in
            // 처음화면으로 전환
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mySideMenu?.dismiss(animated: false, completion: nil)
            appDelegate.mainViewController?.viewLogOut()

        })
        // "아니요" 클릭 시 실행 액션
        let noAlert = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
        
        logoutAlert.addAction(yesAlert)
        logoutAlert.addAction(noAlert)
        
        present(logoutAlert, animated: true, completion: nil)
        
    }
    
}
