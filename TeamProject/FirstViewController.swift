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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var splashView: UIView!
    
        
//        [[KOSession, sharedSession], logoutAndCloseWithCompletionHandler,:^(BOOL success, NSError *error) {
//            if (success) {
//            // logout success.
//            } else {
//            // failed
//            NSLog(@"failed to logout.");
//            }
//            }];
        
//        func profile(_ error: Error?, user: KOUserMe?) {
//            guard let user = user,
//                error == nil else {
//                    return
//            }
//            guard let token = user.id else {
//                return
//            }
//            let name = user.nickname ?? ""
//
//            if let gender = user.account?.gender {
//                if gender == KOUserGender.male {
//                    print("male")
//                } else if gender == KOUserGender.female {
//                    print("female")
//                }
//            }
//            let email = user.account?.email ?? ""
//            let profile = user.profileImageURL?.absoluteString ?? ""
//            let thumnail = user.thumbnailImageURL?.absoluteString ?? ""
//
//            print(token)
//            print(name)
//            print(email)
//            print(profile)
//            print(thumnail)
//        }
//        KOSession.shared()?.open(completionHandler: {(error) in
//            if error != nil || !(KOSession.shared()?.isOpen())! {
//                return
//            }
//            KOSessionTask.userMeTask(completion: {(error, user) in
//                if let account = user?.account {
//                    var updateScopes = [String]()
//
//                    if account.needsScopeGender() {
//                        updateScopes.append("gender")
//                    }
//
//                    KOSessionTask.userMeTask(completion: {(error, user) in
//                        profile(error, user: user)
//                    })
//            } else {
//                profile(error, user: user)
//            }
//        })
//    })
//}

//    guard; let session = KOSession.shared(); else {
//            return
//        }
//
//        if session.isOpen() {
//
//            session.close()
//        }
//
//        session.open(completionHandler: { (error) -> Void in
//
//            if !session.isOpen() {
//
//                if let error = error as NSError? {
//                    switch error.code {
//                    case Int(KOErrorCancelled.rawValue):
//                        break
//                    default:
//                        UIAlertController.showMessage(error.description)
//                    }
//                }
//            }
//        })
    
    var timerShow:Timer? = nil
    var flag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let gradient: CAGradientLayer = CAGradientLayer()
        let gradient2: CAGradientLayer = CAGradientLayer()
        

        gradient.colors = [ UIColor(red: 185/255, green: 225/255, blue: 236/255, alpha: 255/255).cgColor, UIColor(red:67/255, green:175/255, blue:185/255, alpha: 255/255).cgColor ]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        gradient2.colors = [ UIColor(red: 185/255, green: 225/255, blue: 236/255, alpha: 255/255).cgColor, UIColor(red:67/255, green:175/255, blue:185/255, alpha: 255/255).cgColor ]
        gradient2.locations = [0.0 , 1.0]
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient2.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient2.frame = CGRect(x: 0.0, y: 0.0, width: self.splashView.frame.size.width, height: self.splashView.frame.size.height)
        self.splashView.layer.insertSublayer(gradient2, at: 0)
        
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
}

    
//            DispatchQueue.main.async(execute: { () -> Void in
//                print("SUCCESS GET PROFILE!!\n")
//                guard (self.getAppDelegate()) != nil else{
//                    return
//                }
//
//                //Google DB Update
//                var info = UserInfo()
//                info.joinAddress = "kakao"
//
//                if let nickName = profile!.property(forKey: KOUserNicknamePropertyKey) as? String{
//                    info.name = "\(nickName)"
//                }
//
//                if let value = profile!.email{
//                    print("kakao email : \(value)\r\n")
//                    info.email =  "\(value)"
//                }
//
//                if let value = profile!.id{
//                    print("kakao email : \(value)\r\n")
//                    info.id =  "\(value)"
//                }
//
//                print("READY FOR KAKAO PROFILE!!\n")
//                let appDelegate = self.getAppDelegate()
//
//                appDelegate?.addUserProfile(uid: appDelegate?.getDatabaseRef().childByAutoId().key, userInfo: info)
//
//                self.gotoMainViewController(user: info)
//                print("SAVE FOR KAKAO PROFILE!!\n")
//            })
//        }
//    }

