//
//  ForgotPasswordViewController.swift
//  TeamProject
//
//  Created by 황재현 on 29/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        
        emailTextField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height-1, width: emailTextField.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        emailTextField.layer.addSublayer((border))
        emailTextField.textAlignment = .left
        emailTextField.textColor = UIColor.black
    }
    
    func showAlert(message:String){
        
        let alert = UIAlertController(title: "",message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        
        guard let email = emailTextField.text, email != ""  else {
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            
        }
        
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        
        self.showAlert(message: "입력하신 이메일로 \n 인증메일이 발송되었습니다.")
        
    }
    
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
