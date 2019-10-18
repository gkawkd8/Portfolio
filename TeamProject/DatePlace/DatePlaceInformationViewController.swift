//
//  DatePlaceInformationViewController.swift
//  TeamProject
//
//  Created by 황재현 on 26/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Toast_Swift

class DatePlaceInformationViewController: UIViewController {
    var datePlaceViewController: DatePlaceViewController? = nil
    var structDP: StructDatePlace = StructDatePlace()
    var structLike: StructLike = StructLike()
    var arrayDP = Array<StructDatePlace>()
    var dicFavorite:[String:Any]? = nil
    
    var db: Firestore!
    let storage = Storage.storage()
    
    var placeName: String = ""
    var isFavorite = false
    
    @IBOutlet weak var lblSideTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContents: UILabel!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblParking: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()

        lblSideTitle.text = structDP.title
        titleView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1)
        
        imgView.sd_setImage(with: URL(string: structDP.image!), placeholderImage: UIImage(named: "placeholder.png"))
        lblTitle.text = structDP.title
        let newDPContents = structDP.contents?.replacingOccurrences(of: "\\n", with: "\n")
        lblContents.text = newDPContents
        let newDPPrice = structDP.price?.replacingOccurrences(of: "\\n", with: "\n")
        lblPrice.text = newDPPrice
        let newDPAddress = structDP.address?.replacingOccurrences(of: "\\n", with: "\n")
        lblAddress.text = newDPAddress
        let newDPBusiness = structDP.business?.replacingOccurrences(of: "\\n", with: "\n")
        lblBusiness.text = newDPBusiness
        lblParking.text = structDP.parking
    
        lblPrice.numberOfLines = 0
        lblPrice.lineBreakMode = .byWordWrapping
        
        lblContents.numberOfLines = 0
        lblContents.lineBreakMode = .byWordWrapping
        
        lblAddress.numberOfLines = 0
        lblAddress.lineBreakMode = .byWordWrapping
        
        lblBusiness.numberOfLines = 0
        lblBusiness.lineBreakMode = .byWordWrapping
        
        informationView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        btnPhoneNumber.setTitle(structDP.tel, for: .normal)
        btnPhoneNumber.setTitleColor(UIColor.blue, for: .normal)
        btnPhoneNumber.layer.borderColor = UIColor.blue.cgColor
        btnPhoneNumber.layer.borderWidth = 1
        btnPhoneNumber.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(dicFavorite!["dateplaceArray"]!)
        print(structLike.dateplaceArray!)
        var boolFavorite = false
        
        // '좋아요'가 되있는지 장소이름 확인 후 있으면 '좋아요'가 적용
        for placeName in self.dicFavorite!["dateplaceArray"] as! NSArray {
            if let name = placeName as? String {
                if name ==  self.structDP.title {
                    print("좋아요적용")
                    boolFavorite = true
                    break
                }
            }
        }
        if boolFavorite == true {
            self.isFavorite = true
            self.btnLike.setImage(UIImage(named: "likeon.png"), for: .normal)
        } else {
            self.isFavorite = false
             self.btnLike.setImage(UIImage(named: "likeoff.png"), for: .normal)
        }
    }
    
    @IBAction func btnCall(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "telprompt://\(structDP.tel ?? "")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    @IBAction func btnLikeClicked(_ sender: UIButton) {
        // '좋아요'를 취소했을 때
        if isFavorite == true {
            self.isFavorite = false
            btnLike.setImage(UIImage(named: "likeoff.png"), for: .normal)
            structLike.dateplaceLikeCount! -= 1
            self.view.makeToast("저장이 삭제되었습니다.", duration: 2.0, position: .bottom)
            // '좋아요'를 취소했을 때 눌른 정보를 찜한 목록에서 삭제
            let docRef = db.collection("places/\(placeName)/dateplaces").document("\(structDP.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    if self.structLike.dateplaceArray![0] == self.structDP.title &&
                        self.structLike.dateplaceUID![0] == self.structDP.uid {
                        self.structLike.dateplaceArray![0] = ""
                        self.structLike.dateplaceUID![0] = ""
                        self.structLike.dateplacePath![0] = ""
                        self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
                        self.uidupdateDate(uid: self.structLike.dateplaceUID!)
                        self.pathupdateDate(path: self.structLike.dateplacePath!)
                        self.likeupdateDate(count: self.structLike.dateplaceLikeCount!)
                        print(self.structLike.dateplaceArray!)
                        print(self.structLike.dateplaceUID!)
                        print(self.structLike.dateplacePath!)
                        print(self.structLike.dateplaceLikeCount!)
                        
                        self.datePlaceViewController?.structLike = self.structLike
                    } else if self.structLike.dateplaceArray![1] == self.structDP.title &&
                        self.structLike.dateplaceUID![1] == self.structDP.uid {
                        self.structLike.dateplaceArray![1] = ""
                        self.structLike.dateplaceUID![1] = ""
                        self.structLike.dateplacePath![1] = ""
                        self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
                        self.uidupdateDate(uid: self.structLike.dateplaceUID!)
                        self.pathupdateDate(path: self.structLike.dateplacePath!)
                        self.likeupdateDate(count: self.structLike.dateplaceLikeCount!)
                        print(self.structLike.dateplaceArray!)
                        print(self.structLike.dateplaceUID!)
                        print(self.structLike.dateplacePath!)
                        print(self.structLike.dateplaceLikeCount!)
                        
                        self.datePlaceViewController?.structLike = self.structLike
                    } else if self.structLike.dateplaceArray![2] == self.structDP.title &&
                        self.structLike.dateplaceUID![2] == self.structDP.uid {
                        self.structLike.dateplaceArray![2] = ""
                        self.structLike.dateplaceUID![2] = ""
                        self.structLike.dateplacePath![2] = ""
                        self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
                        self.uidupdateDate(uid: self.structLike.dateplaceUID!)
                        self.pathupdateDate(path: self.structLike.dateplacePath!)
                        self.likeupdateDate(count: self.structLike.dateplaceLikeCount!)
                        print(self.structLike.dateplaceArray!)
                        print(self.structLike.dateplaceUID!)
                        print(self.structLike.dateplacePath!)
                        print(self.structLike.dateplaceLikeCount!)
                        
                        self.datePlaceViewController?.structLike = self.structLike
                    }
                } else {
                    print("Document does not exist")
                }
            }
        } else {
            // '좋아요'를 했을 때
            for placeName in self.dicFavorite!["dateplaceArray"] as! NSArray {
                if let name = placeName as? String {
                    if name.count > 0 {
                        print(self.structLike.dateplaceLikeCount!)
                    }
                }
            }
            if structLike.dateplaceLikeCount! >= 3 {
                // '좋아요'의 갯수가 3개 초과되면 alert창 생성
                let logoutAlert = UIAlertController(title: "", message: "더 이상 찜하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                let noAlert = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                logoutAlert.addAction(noAlert)
                
                present(logoutAlert, animated: true, completion: nil)
                
                return
            }
            self.isFavorite = true
            btnLike.setImage(UIImage(named: "likeon.png"), for: .normal)
            self.view.makeToast("항목이 저장됩니다.", duration: 2.0, position: .bottom)
            self.structLike.dateplaceLikeCount! += 1
            // '좋아요'를 눌렀을 때 눌른 정보를 찜한 목록에 저장
            let docRef = db.collection("places/\(placeName)/dateplaces").document("\(structDP.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    if self.structLike.dateplaceArray![0] == "" {
                        self.structLike.dateplaceArray![0] = self.structDP.title ?? "테스트1"
                        self.structLike.dateplaceUID![0] = self.structDP.uid ?? "uid test1"
                        self.structLike.dateplacePath![0] = "places/\(self.placeName)/dateplaces/\(self.structDP.docID!)"
                        self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
                        self.uidupdateDate(uid: self.structLike.dateplaceUID!)
                        self.pathupdateDate(path: self.structLike.dateplacePath!)
                        self.likeupdateDate(count: self.structLike.dateplaceLikeCount!)
                        print(self.structLike.dateplaceArray!)
                        print(self.structLike.dateplaceUID!)
                        print(self.structLike.dateplacePath!)
                        print(self.structLike.dateplaceLikeCount!)
                        
                        self.datePlaceViewController?.structLike = self.structLike
                    } else if self.structLike.dateplaceArray![1] == "" {
                        self.structLike.dateplaceArray![1] = self.structDP.title ?? "테스트2"
                        self.structLike.dateplaceUID![1] = self.structDP.uid ?? "uid test2"
                        self.structLike.dateplacePath![1] = "places/\(self.placeName)/dateplaces/\(self.structDP.docID!)"
                        self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
                        self.uidupdateDate(uid: self.structLike.dateplaceUID!)
                        self.pathupdateDate(path: self.structLike.dateplacePath!)
                        self.likeupdateDate(count: self.structLike.dateplaceLikeCount!)
                        print(self.structLike.dateplaceArray!)
                        print(self.structLike.dateplaceUID!)
                        print(self.structLike.dateplacePath!)
                        print(self.structLike.dateplaceLikeCount!)
                        
                        self.datePlaceViewController?.structLike = self.structLike
                    } else if self.structLike.dateplaceArray![2] == "" {
                        self.structLike.dateplaceArray![2] = self.structDP.title ?? "테스트3"
                        self.structLike.dateplaceUID![2] = self.structDP.uid ?? "uid test3"
                        self.structLike.dateplacePath![2] = "places/\(self.placeName)/dateplaces/\(self.structDP.docID!)"
                        self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
                        self.uidupdateDate(uid: self.structLike.dateplaceUID!)
                        self.pathupdateDate(path: self.structLike.dateplacePath!)
                        self.likeupdateDate(count: self.structLike.dateplaceLikeCount!)
                        print(self.structLike.dateplaceArray!)
                        print(self.structLike.dateplaceUID!)
                        print(self.structLike.dateplacePath!)
                        print(self.structLike.dateplaceLikeCount!)
                        
                        self.datePlaceViewController?.structLike = self.structLike
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    // 업데이트 함수
    func likeupdateDate(count: Int) {
        db = Firestore.firestore()

        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["dateplaceLikeCount": count])
        }
    }
    func arrayupdateDate(arr: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["dateplaceArray": arr])
        }
    }
    func uidupdateDate(uid: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["dateplaceUID": uid])
        }
    }
    func pathupdateDate(path: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["dateplacePath": path])
        }
    }
    
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


// dateplaceArray, dateplaceUID, dateplacelike
//        if self.structLike.dateplaceArray![0] == self.structDP.title ||
//            self.structLike.dateplaceArray![1] == self.structDP.title ||
//            self.structLike.dateplaceArray![2] == self.structDP.title {
//            self.btnLike.setImage(UIImage(named: "likeon.png"), for: .normal)
//        } else {
//            self.btnLike.setImage(UIImage(named: "likeoff.png"), for: .normal)
//        }

//if structLike.dateplaceArray![0] != structDP.title ||
//    structLike.dateplaceArray![1] != structDP.title ||
//    structLike.dateplaceArray![2] != structDP.title {
//
//    if structLike.dateplaceLikeCount! == 3 {
//        let logoutAlert = UIAlertController(title: "", message: "더 이상 찜하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
//        let noAlert = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
//        logoutAlert.addAction(noAlert)
//
//        present(logoutAlert, animated: true, completion: nil)
//    } else {
//        btnLike.setImage(UIImage(named: "likeon.png"), for: .normal)
//        structLike.dateplaceLikeCount! += 1
//        // firestore에 있는 bool, likeCount값 업데이트
//        likeupdateDate(count: structLike.dateplaceLikeCount!)
//        self.view.makeToast("항목이 저장됩니다.", duration: 2.0, position: .bottom)
//        // '좋아요'를 눌렀을 때 눌른 정보를 찜한 목록에 저장
//        let docRef = db.collection("places/\(placeName)/dateplaces").document("\(structDP.docID!)")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//                if self.structLike.dateplaceArray![0] == "" {
//                    self.structLike.dateplaceArray![0] = self.structDP.title ?? "테스트1"
//                    self.structLike.dateplaceUID![0] = self.structDP.uid ?? "uid test1"
//                    self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
//                    self.uidupdateDate(uid: self.structLike.dateplaceUID!)
//                    print(self.structLike.dateplaceArray![0])
//                } else if self.structLike.dateplaceArray![1] == "" {
//                    self.structLike.dateplaceArray![1] = self.structDP.title ?? "테스트2"
//                    self.structLike.dateplaceUID![1] = self.structDP.uid ?? "uid test2"
//                    self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
//                    self.uidupdateDate(uid: self.structLike.dateplaceUID!)
//                    print(self.structLike.dateplaceArray![1])
//                } else if self.structLike.dateplaceArray![2] == "" {
//                    self.structLike.dateplaceArray![2] = self.structDP.title ?? "테스트3"
//                    self.structLike.dateplaceUID![2] = self.structDP.uid ?? "uid test3"
//                    self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
//                    self.uidupdateDate(uid: self.structLike.dateplaceUID!)
//                    print(self.structLike.dateplaceArray![2])
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
//} else if structLike.dateplaceArray![0] == structDP.title ||
//    structLike.dateplaceArray![1] == structDP.title ||
//    structLike.dateplaceArray![2] == structDP.title {
//    btnLike.setImage(UIImage(named: "likeoff.png"), for: .normal)
//    structLike.dateplaceLikeCount! -= 1
//    // firestore에 있는 bool, likeCount값 업데이트
//    likeupdateDate(count: structLike.dateplaceLikeCount!)
//    self.view.makeToast("저장이 삭제되었습니다.", duration: 2.0, position: .bottom)
//    // '좋아요'를 취소했을 때 눌른 정보를 찜한 목록에서 삭제
//    let docRef = db.collection("places/\(placeName)/dateplaces").document("\(structDP.docID!)")
//
//    docRef.getDocument { (document, error) in
//        if let document = document, document.exists {
//            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//            print("Document data: \(dataDescription)")
//            if self.structLike.dateplaceArray![0] == self.structDP.title &&
//                self.structLike.dateplaceUID![0] == self.structDP.uid {
//                self.structLike.dateplaceArray![0] = ""
//                self.structLike.dateplaceUID![0] = ""
//                self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
//                self.uidupdateDate(uid: self.structLike.dateplaceUID!)
//            } else if self.structLike.dateplaceArray![1] == self.structDP.title &&
//                self.structLike.dateplaceUID![1] == self.structDP.uid {
//                self.structLike.dateplaceArray![1] = ""
//                self.structLike.dateplaceUID![1] = ""
//                self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
//                self.uidupdateDate(uid: self.structLike.dateplaceUID!)
//            } else if self.structLike.dateplaceArray![2] == self.structDP.title &&
//                self.structLike.dateplaceUID![2] == self.structDP.uid {
//                self.structLike.dateplaceArray![2] = ""
//                self.structLike.dateplaceUID![2] = ""
//                self.arrayupdateDate(arr: self.structLike.dateplaceArray!)
//                self.uidupdateDate(uid: self.structLike.dateplaceUID!)
//            }
//        } else {
//            print("Document does not exist")
//        }
//    }
//}
