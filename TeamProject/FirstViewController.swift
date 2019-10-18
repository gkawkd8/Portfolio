//
//  ViewController.swift
//  TeamProject
//
//  Created by 조정현 on 27/07/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var splashLabel: UILabel!
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    
    var timerShow:Timer? = nil
    var flag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        btnLogin.layer.borderColor = UIColor.clear.cgColor
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.cornerRadius = 5
        
        btnJoin.layer.borderColor = UIColor.clear.cgColor
        btnJoin.layer.borderWidth = 1
        btnJoin.layer.cornerRadius = 5
        
        self.setNavigationBar()
        
        splashLabel.alpha = 0
        UIView.animate(withDuration: 3.0, animations: ({
            self.splashLabel.alpha  = 1;
        }))
        func showTimer() {
            timerShow = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {
                (timer) -> Void in
                self.flag = true
                if self.flag == true {
                    //                    self.imgView.isHidden = true
                    //                    self.splashLabel.isHidden = true
                    self.splashView.isHidden = true
                }
            })
        }
        showTimer()
        if flag == false {
            //            imgView.isHidden = false
            //            splashLabel.isHidden = false
            splashView.isHidden = false
        } else if flag == true {
            timerShow?.invalidate()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setNavigationBar(){
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    @IBAction func btnLogin(_ sender: UIButton) {
        
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    @IBAction func btnJoin(_ sender: UIButton) {
        
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "CreateIDViewController") as UIViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}


