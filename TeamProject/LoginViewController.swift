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
    
    var databaseRefer : DatabaseReference!
    var databaseHandle : DatabaseHandle!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
    
//        if Auth.auth().currentUser != nil {
//            self.emailTextField.placeholder = "이미 로그인 된 상태입니다."
//            self.emailTextField.isEnabled = false
//            self.passwordTextField.placeholder = "이미 로그인 된 상태입니다."
//            self.passwordTextField.isEnabled = false
//            self.btnLogin.setTitle("로그아웃", for: .normal)
//        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [ UIColor(red: 185/255, green: 225/255, blue: 236/255, alpha: 255/255).cgColor, UIColor(red:67/255, green:175/255, blue:185/255, alpha: 255/255).cgColor ]
        
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)

    }

    @IBAction func btnLoginClicked(_ sender: Any) {
     
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                
                self.performSegue(withIdentifier: "MapView", sender: self)
                print("Login success")

                let dialog = UIAlertController(title: "", message: "지역을 선택해주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
                
                self.databaseRefer = Database.database().reference()
                let uid = Auth.auth().currentUser?.uid ?? "None"
                self.databaseRefer.child("users/\(uid)").setValue(self.emailTextField.text)
                self.databaseHandle = self.databaseRefer.child("users").observe(.childAdded, with: { (data) in
                    let name : String = ((data.value as? String)!)
                    debugPrint(name)
                })
   
            } else {
                let dialog = UIAlertController(title: "", message: "이메일 또는 비밀번호가 올바르지 않습니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
                print("Login fail")
            }
        }
    }
//            if self.btnLogin.title(for: .normal) == "로그아웃" {
//            self.emailTextField.placeholder = "E-mail"
//            self.emailTextField.isEnabled = true
//            self.passwordTextField.placeholder = "Password"
//            self.passwordTextField.isEnabled = true
//            self.btnLogin.setTitle("로그인", for: .normal)
//            }
//        }
    @IBAction func kakaoAction(_ sender: Any) {
        
        func profile(_ error: Error?, user: KOUserMe?) {
            guard let user = user,
                error == nil else {
                    return
            }
            guard let token = user.id else {
                return
            }
            let name = user.nickname ?? ""
            
            if let gender = user.account?.gender {
                if gender == KOUserGender.male {
                    print("male")
                } else if gender == KOUserGender.female {
                    print("female")
                }
            }
            let email = user.account?.email ?? ""
            let profile = user.profileImageURL?.absoluteString ?? ""
            let thumnail = user.thumbnailImageURL?.absoluteString ?? ""
            
            print(token)
            print(name)
            print(email)
            print(profile)
            print(thumnail)
        }
        
        KOSession.shared()?.open(completionHandler: {(error) in
            if error != nil || !(KOSession.shared()?.isOpen())! {
                return
            }
            KOSessionTask.userMeTask(completion: {(error, user) in
                if let account = user?.account {
                    var updateScopes = [String]()
                    
                    if account.needsScopeGender() {
                        updateScopes.append("gender")
                    }
                    
                    KOSessionTask.userMeTask(completion: {(error, user) in
                        profile(error, user: user)
                    })
                } else {
                    profile(error, user: user)
                }
            })
        })
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

}
