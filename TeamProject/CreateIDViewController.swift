//
//  CreateIDViewController.swift
//  TeamProject
//
//  Created by 조정현 on 28/07/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateIDViewController: UIViewController {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLayoutSubviews() {
        
        textName.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: textName.frame.size.height-1, width: textName.frame.width, height: 1)
        border.backgroundColor = UIColor.white.cgColor
        textName.layer.addSublayer((border))
        textName.textAlignment = .left
        textName.textColor = UIColor.white
        
        textEmail.borderStyle = .none
        let border2 = CALayer()
        border2.frame = CGRect(x: 0, y: textEmail.frame.size.height-1, width: textEmail.frame.width, height: 1)
        border2.backgroundColor = UIColor.white.cgColor
        textEmail.layer.addSublayer((border2))
        textEmail.textAlignment = .left
        textEmail.textColor = UIColor.white
        
        textPassword.borderStyle = .none
        let border3 = CALayer()
        border3.frame = CGRect(x: 0, y: textPassword.frame.size.height-1, width: textPassword.frame.width, height: 1)
        border3.backgroundColor = UIColor.white.cgColor
        textPassword.layer.addSublayer((border3))
        textPassword.textAlignment = .left
        textPassword.textColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [ UIColor(red: 185/255, green: 225/255, blue: 236/255, alpha: 255/255).cgColor, UIColor(red:67/255, green:175/255, blue:185/255, alpha: 255/255).cgColor ]
        
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)

    }
    
    @IBAction func btnCreateID(_ sender: Any) {

        if let textID = textEmail.text, let textPW = textPassword.text {
            if textID.count < 1 || textPW.count < 6 {
                print("아이디나 암호의 길이가 짧습니다.")
                return
            }
            Auth.auth().createUser(withEmail: textID, password: textPW){ authResult, error in
            guard let user = authResult?.user, error == nil else {
                print(error!.localizedDescription)
                return
            }
                print("\(user.email!) 회원가입 성공함.")
                self.performSegue(withIdentifier: "LoginView", sender: self)
            }
        }else{
            print("아이디나 암호가 입력안됨.")
        }
    }
}
        
//        _ = Auth.auth().currentUser?.uid
//
//        Auth.auth().createUser(withEmail: textEmail.text!, password: textPassword.text!)
//        { (user, error) in
//            if user !=  nil {
//
//                print("Create iD success")
//
//                self.performSegue(withIdentifier: "LoginView", sender: self)
//
////                self.ref = Database.database().reference()
////                let usersRef = self.ref.child("users")
////                usersRef.setValue(self.textEmail.text)
//
//            }else{
//
//                print("Create iD failed")
//
//            }
//        }
//    }
//}
