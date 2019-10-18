//
//  SideMenuViewController.swift
//  TeamProject
//
//  Created by 조정현 on 06/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
//import MobileCoreServices
//struct StructuserName {
//    var name: String? = nil
//}
class SideMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var captureImage: UIImage!
    var flagImageSave = false
    var databaseRefer : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    var db: Firestore!
    let storage = Storage.storage()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    
    @IBAction func btnLogout(_ sender: UIButton) {
        // Alert 창 생성
        let logoutAlert = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        // "네" 클릭 시 실행 액션
        let yesAlert = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: {ACTION in
            // 처음화면으로 전환
            try! Auth.auth().signOut()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mySideMenu?.dismiss(animated: false, completion: nil)
            appDelegate.mainViewController?.viewLogOut()
        })
        // "아니요" 클릭 시 실행 액션
        let noAlert = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
        
        logoutAlert.addAction(yesAlert)
        logoutAlert.addAction(noAlert)
        
        present(logoutAlert, animated: true, completion: nil)
        
        KOSession.shared()?.logoutAndClose(completionHandler: { (success, error) in
            if success {
                // logout
            } else {
                print("logout fail")
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        //        profileName.delegate = self
        profileImage.layer.cornerRadius = profileImage.frame.width / 2 //프레임을 원으로 만들기
        profileName.isEnabled = false
        self.databaseRefer = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        //        let userProfile = Auth.auth().currentUser?.photoURL
        databaseRefer.child("UserData").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //            let profileImage : UIImageView = self.profileImage
            let value = snapshot.value as? NSDictionary
            let username = value?["user_Name"] as? String ?? ""
            let imageUrl = value?["user_Profile"] as? String ?? ""
            let url = URL(string: imageUrl)
            let _: String? = nil
            
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                self.profileImage.image = image
                
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
            
            self.profileName.text = username
            
        }) { (error) in
            print(error.localizedDescription)
        }
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillShowNotification, object: nil)
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        if let image = appDelegate.profileImage {
        //            self.profileImage.image = image
        //        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            self.profileImage.image = image
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.profileImage = image
            
            let uid = Auth.auth().currentUser?.uid ?? "None"
            let storage = Storage.storage()
            let storageRef = storage.reference()
            var data = self.profileImage.image!.pngData()!
            let riversRef = storageRef.child("userProfile/\(uid)/\(String(describing: self.profileImage))")
            let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        var downloadURL = url
                        
                        return
                    }
                    let profileImageUrl = downloadURL.absoluteString
                    self.databaseRefer.child("UserData/\(uid)/user_Profile").setValue(profileImageUrl)
                    self.profileImage.image = UIImage.init(contentsOfFile: downloadURL.absoluteString)
                }
            }
        } else {
            if let image = info[.originalImage] as? UIImage {
                
                self.profileImage.image = image
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.profileImage = image
            }
        }
        picker.dismiss(animated: false, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: false, completion: nil)
        
        let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        
        self.present(alert, animated: false, completion: nil)
    }
    @IBAction func btnProfile(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: false, completion: nil)
        
        let uid = Auth.auth().currentUser?.uid ?? "None"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var data = self.profileImage.image!.pngData()!
        let riversRef = storageRef.child("userProfile/\(uid)/\(String(describing: self.profileImage))")
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    var downloadURL = url
                    
                    return
                }
                let profileImageUrl = downloadURL.absoluteString
                self.databaseRefer.child("UserData/\(uid)/user_Profile").setValue(profileImageUrl)
                self.profileImage.image = UIImage.init(contentsOfFile: downloadURL.absoluteString)
            }
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return true
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: LikeViewController = storyboard.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
