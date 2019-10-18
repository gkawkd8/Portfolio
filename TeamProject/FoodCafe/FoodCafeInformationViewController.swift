//
//  FoodCafeInformationViewController.swift
//  TeamProject
//
//  Created by 황재현 on 29/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Toast_Swift

var arrfoodcafeLike: Array<String> = ["", "", ""]
var arrfoodcafeUID: Array<String> = ["", "", ""]
var intfoodcafeCount: Int = 0

class FoodCafeInformationViewController: UIViewController {
    var foodCafeViewController: FoodCafeViewController? = nil
    var structFC: StructFoodCafe = StructFoodCafe()
    var arrayFC = Array<StructFoodCafe>()
    var structLike: StructLike = StructLike()
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
        
        lblSideTitle.text = structFC.title
        titleView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1)
        
        imgView.sd_setImage(with: URL(string: structFC.image!), placeholderImage: UIImage(named: "placeholder.png"))
        lblTitle.text = structFC.title
        let newFCContents = structFC.contents?.replacingOccurrences(of: "\\n", with: "\n")
        lblContents.text = newFCContents
        let newFCPrice = structFC.price?.replacingOccurrences(of: "\\n", with: "\n")
        lblPrice.text = newFCPrice
        let newFCAddress = structFC.address?.replacingOccurrences(of: "\\n", with: "\n")
        lblAddress.text = newFCAddress
        let newFCBusiness = structFC.business?.replacingOccurrences(of: "\\n", with: "\n")
        lblBusiness.text = newFCBusiness
        lblParking.text = structFC.parking
    
        lblPrice.numberOfLines = 0
        lblPrice.lineBreakMode = .byWordWrapping
        
        lblContents.numberOfLines = 0
        lblContents.lineBreakMode = .byWordWrapping
        
        lblAddress.numberOfLines = 0
        lblAddress.lineBreakMode = .byWordWrapping
        
        lblBusiness.numberOfLines = 0
        lblBusiness.lineBreakMode = .byWordWrapping
        
        informationView.backgroundColor = UIColor.white
        //contentView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 226/255, alpha: 1)
        //view.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 226/255, alpha: 1)
        contentView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        btnPhoneNumber.setTitle(structFC.tel, for: .normal)
        btnPhoneNumber.setTitleColor(UIColor.blue, for: .normal)
        btnPhoneNumber.layer.borderColor = UIColor.blue.cgColor
        btnPhoneNumber.layer.borderWidth = 1
        btnPhoneNumber.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(dicFavorite!["foodcafeArray"]!)
        print(structLike.foodcafeArray!)
        var boolFavorite = false
        
        // '좋아요'가 되있는지 장소이름 확인 후 있으면 '좋아요'가 적용
        for placeName in self.dicFavorite!["foodcafeArray"] as! NSArray {
            if let name = placeName as? String {
                if name ==  self.structFC.title {
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
        if let phoneCallURL = URL(string: "telprompt://\(structFC.tel ?? "")") {
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
            self.view.makeToast("저장이 삭제되었습니다.", duration: 2.0, position: .bottom)
            self.structLike.foodcafeLikeCount! -= 1
            // '좋아요'를 취소했을 때 눌른 정보를 찜한 목록에서 삭제
            let docRef = db.collection("places/\(placeName)/foodcafe").document("\(structFC.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    if self.structLike.foodcafeArray![0] == self.structFC.title &&
                        self.structLike.foodcafeUID![0] == self.structFC.uid {
                        self.structLike.foodcafeArray![0] = ""
                        self.structLike.foodcafeUID![0] = ""
                        self.structLike.foodcafePath![0] = ""
                        self.arrayupdateDate(arr: self.structLike.foodcafeArray!)
                        self.uidupdateDate(uid: self.structLike.foodcafeUID!)
                        self.pathupdateDate(path: self.structLike.foodcafePath!)
                        self.likeupdateDate(count: self.structLike.foodcafeLikeCount!)
                        print(self.structLike.foodcafeArray!)
                        print(self.structLike.foodcafeUID!)
                        print(self.structLike.foodcafePath!)
                        print(self.structLike.foodcafeLikeCount!)
                        
                        self.foodCafeViewController?.structLike = self.structLike
                    } else if self.structLike.foodcafeArray![1] == self.structFC.title &&
                        self.structLike.foodcafeUID![1] == self.structFC.uid {
                        self.structLike.foodcafeArray![1] = ""
                        self.structLike.foodcafeUID![1] = ""
                        self.structLike.foodcafePath![1] = ""
                        self.arrayupdateDate(arr: self.structLike.foodcafeArray!)
                        self.uidupdateDate(uid: self.structLike.foodcafeUID!)
                        self.pathupdateDate(path: self.structLike.foodcafePath!)
                        self.likeupdateDate(count: self.structLike.foodcafeLikeCount!)
                        print(self.structLike.foodcafeArray!)
                        print(self.structLike.foodcafeUID!)
                        print(self.structLike.foodcafePath!)
                        print(self.structLike.foodcafeLikeCount!)
                        
                        self.foodCafeViewController?.structLike = self.structLike
                    } else if self.structLike.foodcafeArray![2] == self.structFC.title &&
                        self.structLike.foodcafeUID![2] == self.structFC.uid {
                        self.structLike.foodcafeArray![2] = ""
                        self.structLike.foodcafeUID![2] = ""
                        self.structLike.foodcafePath![2] = ""
                        self.arrayupdateDate(arr: self.structLike.foodcafeArray!)
                        self.uidupdateDate(uid: self.structLike.foodcafeUID!)
                        self.pathupdateDate(path: self.structLike.foodcafePath!)
                        self.likeupdateDate(count: self.structLike.foodcafeLikeCount!)
                        print(self.structLike.foodcafeArray!)
                        print(self.structLike.foodcafeUID!)
                        print(self.structLike.foodcafePath!)
                        print(self.structLike.foodcafeLikeCount!)
                        
                        self.foodCafeViewController?.structLike = self.structLike
                    }
                } else {
                    print("Document does not exist")
                }
            }
        } else {
            // '좋아요'를 했을 때
            //var countFavorite = 0
            for placeName in self.dicFavorite!["foodcafeArray"] as! NSArray {
                if let name = placeName as? String {
                    if name.count > 0 {
                        //countFavorite += 1
                    }
                }
            }
            if structLike.foodcafeLikeCount! >= 3 {
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
            structLike.foodcafeLikeCount! += 1
            // '좋아요'를 눌렀을 때 눌른 정보를 찜한 목록에 저장
            let docRef = db.collection("places/\(placeName)/foodcafe").document("\(structFC.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    if self.structLike.foodcafeArray![0] == "" {
                        self.structLike.foodcafeArray![0] = self.structFC.title ?? "테스트1"
                        self.structLike.foodcafeUID![0] = self.structFC.uid ?? "uid test1"
                        self.structLike.foodcafePath![0] = "places/\(self.placeName)/foodcafe/\(self.structFC.docID!)"
                        self.arrayupdateDate(arr: self.structLike.foodcafeArray!)
                        self.uidupdateDate(uid: self.structLike.foodcafeUID!)
                        self.pathupdateDate(path: self.structLike.foodcafePath!)
                        self.likeupdateDate(count: self.structLike.foodcafeLikeCount!)
                        print(self.structLike.foodcafeArray!)
                        print(self.structLike.foodcafeUID!)
                        print(self.structLike.foodcafePath!)
                        print(self.structLike.foodcafeLikeCount!)
                        
                        self.foodCafeViewController?.structLike = self.structLike
                    } else if self.structLike.foodcafeArray![1] == "" {
                        self.structLike.foodcafeArray![1] = self.structFC.title ?? "테스트1"
                        self.structLike.foodcafeUID![1] = self.structFC.uid ?? "uid test1"
                        self.structLike.foodcafePath![1] = "places/\(self.placeName)/foodcafe/\(self.structFC.docID!)"
                        self.arrayupdateDate(arr: self.structLike.foodcafeArray!)
                        self.uidupdateDate(uid: self.structLike.foodcafeUID!)
                        self.pathupdateDate(path: self.structLike.foodcafePath!)
                        self.likeupdateDate(count: self.structLike.foodcafeLikeCount!)
                        print(self.structLike.foodcafeArray!)
                        print(self.structLike.foodcafeUID!)
                        print(self.structLike.foodcafePath!)
                        print(self.structLike.foodcafeLikeCount!)
                        
                        self.foodCafeViewController?.structLike = self.structLike
                    } else if self.structLike.foodcafeArray![2] == "" {
                        self.structLike.foodcafeArray![2] = self.structFC.title ?? "테스트1"
                        self.structLike.foodcafeUID![2] = self.structFC.uid ?? "uid test1"
                        self.structLike.foodcafePath![2] = "places/\(self.placeName)/foodcafe/\(self.structFC.docID!)"
                        self.arrayupdateDate(arr: self.structLike.foodcafeArray!)
                        self.uidupdateDate(uid: self.structLike.foodcafeUID!)
                        self.pathupdateDate(path: self.structLike.foodcafePath!)
                        self.likeupdateDate(count: self.structLike.foodcafeLikeCount!)
                        print(self.structLike.foodcafeArray!)
                        print(self.structLike.foodcafeUID!)
                        print(self.structLike.foodcafePath!)
                        print(self.structLike.foodcafeLikeCount!)
                        
                        self.foodCafeViewController?.structLike = self.structLike
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
            db.collection("favorite").document("\(email)").updateData(["foodcafeLikeCount": count])
        }
    }
    
    func arrayupdateDate(arr: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["foodcafeArray": arr])
        }
    }
    func uidupdateDate(uid: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["foodcafeUID": uid])
        }
    }
    func pathupdateDate(path: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["foodcafePath": path])
        }
    }
    
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
