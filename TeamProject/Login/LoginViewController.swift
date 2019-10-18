//
//  LoginViewController.swift
//  TeamProject
//
//  Created by 조정현 on 27/07/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import KakaoOpenSDK

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    
    var databaseRefer : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailTextField.text = "test7@naver.com"
//        passwordTextField.text = "123456"
        
        //        navigationController?.isNavigationBarHidden = true
        
        btnLogin.layer.borderColor = UIColor.clear.cgColor
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.cornerRadius = 5
        
        btnJoin.layer.borderColor = UIColor.clear.cgColor
        btnJoin.layer.borderWidth = 1
        btnJoin.layer.cornerRadius = 5
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                
                let storyboard: UIStoryboard = self.storyboard!
                let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as UIViewController
                self.navigationController?.pushViewController(newVC, animated: true)
                print("Login success")
                
                let dialog = UIAlertController(title: "", message: "지역을 선택해주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
               
            } else {
                let dialog = UIAlertController(title: "", message: "이메일 또는 비밀번호가 올바르지 않습니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
                print("Login fail")
            }
        }
    }
    @IBAction func kakaoAction(_ sender: Any) {
        
        KOSession.shared()?.open(completionHandler: {(error) in
            if (KOSession.shared()?.isOpen())! {
                
                let storyboard: UIStoryboard = self.storyboard!
                let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as UIViewController
                self.navigationController?.pushViewController(newVC, animated: true)
                
                let dialog = UIAlertController(title: "", message: "지역을 선택해주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                
                self.present(dialog, animated: true, completion: nil)
                
            } else {
                
            }
        })
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as UIViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    override func viewDidLayoutSubviews() {
        
        emailTextField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height-1, width: emailTextField.frame.width, height: 1)
        border.backgroundColor = UIColor.white.cgColor
        emailTextField.layer.addSublayer((border))
        emailTextField.textAlignment = .left
        emailTextField.textColor = UIColor.white
        
        passwordTextField.borderStyle = .none
        let border2 = CALayer()
        border2.frame = CGRect(x: 0, y: passwordTextField.frame.size.height-1, width: passwordTextField.frame.width, height: 1)
        border2.backgroundColor = UIColor.white.cgColor
        passwordTextField.layer.addSublayer((border2))
        passwordTextField.textAlignment = .left
        passwordTextField.textColor = UIColor.white
    }
    @IBAction func btnJoin(_ sender: UIButton) {
        
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "CreateIDViewController") as UIViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        
    }
    
}


