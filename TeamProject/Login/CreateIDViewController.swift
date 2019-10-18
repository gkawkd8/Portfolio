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
import FirebaseStorage
import Toast_Swift

var userUID: String? = nil

struct StructLike {
    var dateplaceLikeCount: Int? = 0
    var performanceLikeCount: Int? = 0
    var foodcafeLikeCount: Int? = 0
    var movieLikeCount: Int? = 0
    
    var dateplaceArray: Array<String>? = ["", "", ""]
    var performanceArray: Array<String>? = ["", "", ""]
    var foodcafeArray: Array<String>? = ["", "", ""]
    var movieArray: Array<String>? = ["", "", ""]
    
    var dateplaceUID: Array<String>? = ["", "", ""]
    var performanceUID: Array<String>? = ["", "", ""]
    var foodcafeUID: Array<String>? = ["", "", ""]
    var movieUID: Array<String>? = ["", "", ""]
    
    var dateplacePath: Array<String>? = ["", "", ""]
    var performancePath: Array<String>? = ["", "", ""]
    var foodcafePath: Array<String>? = ["", "", ""]
    var moviePath: Array<String>? = ["", "", ""]
}

class CreateIDViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var profileImage: UIImageView!

    var captureImage: UIImage!
    var flagImageSave = false
    var databaseRefer : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    var db : Firestore!
    var structLike: StructLike = StructLike()
    
    @IBAction func btnCreateID(_ sender: Any) {
        doSignUp()
    }
    override func viewDidLayoutSubviews() {
        
        btnLogin.layer.borderColor = UIColor.clear.cgColor
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.cornerRadius = 5
        
        btnJoin.layer.borderColor = UIColor.clear.cgColor
        btnJoin.layer.borderWidth = 1
        btnJoin.layer.cornerRadius = 5
        
        textName.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: textName.frame.size.height-1, width: textName.frame.width, height: 1)
        border.backgroundColor = UIColor.lightGray.cgColor
        textName.layer.addSublayer((border))
        textName.textAlignment = .left
        textName.textColor = UIColor.black
        
        textEmail.borderStyle = .none
        let border2 = CALayer()
        border2.frame = CGRect(x: 0, y: textEmail.frame.size.height-1, width: textEmail.frame.width, height: 1)
        border2.backgroundColor = UIColor.lightGray.cgColor
        textEmail.layer.addSublayer((border2))
        textEmail.textAlignment = .left
        textEmail.textColor = UIColor.black
        
        textPassword.borderStyle = .none
        let border3 = CALayer()
        border3.frame = CGRect(x: 0, y: textPassword.frame.size.height-1, width: textPassword.frame.width, height: 1)
        border3.backgroundColor = UIColor.lightGray.cgColor
        textPassword.layer.addSublayer((border3))
        textPassword.textAlignment = .left
        textPassword.textColor = UIColor.black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2 //프레임을 원으로 만들기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let image = appDelegate.profileImage {
            self.profileImage.image = image
        }
    }
    func showAlert(message:String) {
        let alert = UIAlertController(title: "회원가입 실패",message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlert2(message:String) {
        let alert2 = UIAlertController(title: "",message: message, preferredStyle: .alert)
        alert2.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert2, animated: true, completion: nil)
    }
    func doSignUp(){
        if textEmail.text! == ""{
            showAlert(message: "이메일을 입력해주세요.")
            return
        }
        if textPassword.text! == ""{
            showAlert(message: "비밀번호를 입력해주세요.")
            return
        }
        signUp(email: textEmail.text!, password: textPassword.text!)
    }
    
    func signUp(email:String, password:String){
        db = Firestore.firestore()
    
            
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch ErrorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(message: "유효하지 않은 이메일 입니다.")
                    case AuthErrorCode.emailAlreadyInUse:
                        self.showAlert(message: "이미 가입한 회원 입니다.")
                    case AuthErrorCode.weakPassword:
                        self.showAlert(message: "비밀번호는 6자리 이상이여야 합니다.")
                    default:
                        print(ErrorCode)
                    }
                }
            } else {
                // 회원가입 시 '좋아요' 눌렀을 때 데이터를 넣을 컬랙션 생성
                self.db.collection("favorite").document("\(email)").setData( [
                    "dateplaceArray": ["", "", ""],
                    "performanceArray": ["", "", ""],
                    "foodcafeArray": ["", "", ""],
                    "movieArray": ["", "", ""],
                    "dateplaceUID": ["", "", ""],
                    "performanceUID": ["", "", ""],
                    "foodcafeUID": ["", "", ""],
                    "movieUID": ["", "", ""],
                    
                    "dateplacePath": ["", "", ""],
                    "performancePath": ["", "", ""],
                    "foodcafePath": ["", "", ""],
                    "moviePath": ["", "", ""],
                    "dateplaceLikeCount": 0,
                    "performanceLikeCount": 0,
                    "foodcafeLikeCount": 0,
                    "movieLikeCount": 0
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID")
                        
                        
                        // 회원가입한 'email' 문서의 모든 정보를 읽음
                        self.db.collection("favorite").document("\(email)").getDocument { (document, error) in
                            if let docData = document, docData.exists {
                               // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                               // print("Document data: \(dataDescription)")
                                
                                print("\(docData.documentID) => \(docData.data())")
                                let docData = docData.data()
                                
                                let dateplaceLikeCount = docData!["dateplaceLikeCount"] as? Int ?? 0
                                print("dateplaceLikeCount: \(dateplaceLikeCount)")
                                let performanceLikeCount = docData!["performanceLikeCount"] as? Int ?? 0
                                print("performanceLikeCount: \(performanceLikeCount)")
                                let foodcafeLikeCount = docData!["foodcafeLikeCount"] as? Int ?? 0
                                print("foodcafeLikeCount: \(foodcafeLikeCount)")
                                let movieLikeCount = docData!["movieLikeCount"] as? Int ?? 0
                                
                                print("movieLikeCount: \(movieLikeCount)")
                                let dateplaceArray = docData!["dateplaceArray"] as? Array ?? ["", "", ""]
                                print("dateplaceArray: \(dateplaceArray)")
                                let performanceArray = docData!["performanceArray"] as? Array ?? ["", "", ""]
                                print("performanceArray: \(performanceArray)")
                                let foodcafeArray = docData!["foodcafeArray"] as? Array ?? ["", "", ""]
                                print("foodcafeArray: \(foodcafeArray)")
                                let movieArray = docData!["movieArray"] as? Array ?? ["", "", ""]
                                print("movieArray: \(movieArray)")
                                
                                let dateplaceUID = docData!["dateplaceUID"] as? Array ?? ["", "", ""]
                                print("dateplaceUID: \(dateplaceUID)")
                                let performanceUID = docData!["performanceUID"] as? Array ?? ["", "", ""]
                                print("performanceUID: \(performanceUID)")
                                let foodcafeUID = docData!["foodcafeUID"] as? Array ?? ["", "", ""]
                                print("foodcafeUID: \(foodcafeUID)")
                                let movieUID = docData!["movieUID"] as? Array ?? ["", "", ""]
                                print("movieUID: \(movieUID)")
                                
                                let dateplacePath = docData!["dateplacePath"] as? Array ?? ["", "", ""]
                                print("dateplacePath: \(dateplacePath)")
                                let performancePath = docData!["performancePath"] as? Array ?? ["", "", ""]
                                print("performancePath: \(performancePath)")
                                let foodcafePath = docData!["foodcafePath"] as? Array ?? ["", "", ""]
                                print("foodcafePath: \(foodcafePath)")
                                let moviePath = docData!["moviePath"] as? Array ?? ["", "", ""]
                                print("moviePath: \(moviePath)")
                                
                                var structLike: StructLike = StructLike()
                                structLike.dateplaceLikeCount = dateplaceLikeCount
                                structLike.performanceLikeCount = performanceLikeCount
                                structLike.foodcafeLikeCount = foodcafeLikeCount
                                structLike.movieLikeCount = movieLikeCount
                                structLike.dateplaceArray = dateplaceArray
                                structLike.performanceArray = performanceArray
                                structLike.foodcafeArray = foodcafeArray
                                structLike.movieArray = movieArray
                                structLike.dateplaceUID = dateplaceUID
                                structLike.performanceUID = performanceUID
                                structLike.foodcafeUID = foodcafeUID
                                structLike.movieUID = movieUID
                                structLike.dateplacePath = dateplacePath
                                structLike.performancePath = performancePath
                                structLike.foodcafePath = foodcafePath
                                structLike.moviePath = moviePath
            
                                print("회원가입 성공")
                                dump(user)
                                
                                let storyboard: UIStoryboard = self.storyboard!
                                let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
                                self.navigationController?.pushViewController(newVC, animated: true)
                                self.showAlert2(message: "회원가입이 완료되었습니다.")
                                
                                self.databaseRefer = Database.database().reference()
                                let uid = Auth.auth().currentUser?.uid ?? "None"
                                self.databaseRefer.child("UserData/\(uid)/user_Email").setValue(self.textEmail.text)
                                self.databaseRefer.child("UserData/\(uid)/user_Name").setValue(self.textName.text)
                                
                                self.databaseHandle = self.databaseRefer.child("users/\(uid)/name").observe(.childAdded, with: { (data) in
                                    let name : String = ((data.value as? String)!)
                                    debugPrint(name)
                                })
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
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            self.profileImage.image = image
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.profileImage = image
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
    }
}
