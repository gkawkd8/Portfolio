//
//  PerformanceInformationViewController.swift
//  TeamProject
//
//  Created by 황재현 on 12/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Toast_Swift

var arrperformanceLike: Array<String> = ["", "", ""]
var arrperformanceUID: Array<String> = ["", "", ""]
var intperformanceCount: Int = 0

class PerformanceInformationViewController: UIViewController {
    var performanceViewController: PerformanceViewController? = nil
    var structPerf: StructPerformance = StructPerformance()
    var structLike: StructLike = StructLike()
    var arrayPerformance = Array<StructPerformance>()
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
        
        lblSideTitle.text = structPerf.title
        titleView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1)
        self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        imgView.sd_setImage(with: URL(string: structPerf.image!), placeholderImage: UIImage(named: "placeholder.png"))
        lblTitle.text = structPerf.title
        let newPerContents = structPerf.contents?.replacingOccurrences(of: "\\n", with: "\n")
        lblContents.text = newPerContents
        let newPerPrice = structPerf.price?.replacingOccurrences(of: "\\n", with: "\n")
        lblPrice.text = newPerPrice
        let newPerAddress = structPerf.address?.replacingOccurrences(of: "\\n", with: "\n")
        lblAddress.text = newPerAddress
        let newPerBusiness = structPerf.business?.replacingOccurrences(of: "\\n", with: "\n")
        lblBusiness.text = newPerBusiness
        lblParking.text = structPerf.parking
        
        if structPerf.like == false {
            btnLike.setImage(UIImage(named: "likeoff.png"), for: .normal)
        } else if structPerf.like == true {
            btnLike.setImage(UIImage(named: "likeon.png"), for: .normal)
        }
        
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
        
        btnPhoneNumber.setTitle(structPerf.tel, for: .normal)
        btnPhoneNumber.setTitleColor(UIColor.blue, for: .normal)
        btnPhoneNumber.layer.borderColor = UIColor.blue.cgColor
        btnPhoneNumber.layer.borderWidth = 1
        btnPhoneNumber.layer.cornerRadius = 5
    }
    override func viewWillAppear(_ animated: Bool) {
        print(dicFavorite!["performanceArray"]!)
        print(structLike.performanceArray!)
        var boolFavorite = false
        
        // '좋아요'가 되있는지 장소이름 확인 후 있으면 '좋아요'가 적용
        for placeName in self.dicFavorite!["performanceArray"] as! NSArray {
            if let name = placeName as? String {
                if name ==  self.structPerf.title {
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
        if let phoneCallURL = URL(string: "telprompt://\(structPerf.tel ?? "")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }else{
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
            self.structLike.performanceLikeCount! -= 1
            // '좋아요'를 취소했을 때 눌른 정보를 찜한 목록에서 삭제
            let docRef = db.collection("places/\(placeName)/performances").document("\(structPerf.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    if self.structLike.performanceArray![0] == self.structPerf.title &&
                        self.structLike.performanceUID![0] == self.structPerf.uid {
                        self.structLike.performanceArray![0] = ""
                        self.structLike.performanceUID![0] = ""
                        self.structLike.performancePath![0] = ""
                        self.arrayupdateDate(arr: self.structLike.performanceArray!)
                        self.uidupdateDate(uid: self.structLike.performanceUID!)
                        self.pathupdateDate(path: self.structLike.performancePath!)
                        self.likeupdateDate(count: self.structLike.performanceLikeCount!)
                        print(self.structLike.performanceArray!)
                        print(self.structLike.performanceUID!)
                        print(self.structLike.performancePath!)
                        print(self.structLike.performanceLikeCount!)
                        
                        self.performanceViewController?.structLike = self.structLike
                    } else if self.structLike.performanceArray![1] == self.structPerf.title &&
                        self.structLike.performanceUID![1] == self.structPerf.uid {
                        self.structLike.performanceArray![1] = ""
                        self.structLike.performanceUID![1] = ""
                        self.structLike.performancePath![1] = ""
                        self.arrayupdateDate(arr: self.structLike.performanceArray!)
                        self.uidupdateDate(uid: self.structLike.performanceUID!)
                        self.pathupdateDate(path: self.structLike.performancePath!)
                        self.likeupdateDate(count: self.structLike.performanceLikeCount!)
                        print(self.structLike.performanceArray!)
                        print(self.structLike.performanceUID!)
                        print(self.structLike.performancePath!)
                        print(self.structLike.performanceLikeCount!)
                        
                        self.performanceViewController?.structLike = self.structLike
                    } else if self.structLike.performanceArray![2] == self.structPerf.title &&
                        self.structLike.performanceUID![2] == self.structPerf.uid {
                        self.structLike.performanceArray![2] = ""
                        self.structLike.performanceUID![2] = ""
                        self.structLike.performancePath![2] = ""
                        self.arrayupdateDate(arr: self.structLike.performanceArray!)
                        self.uidupdateDate(uid: self.structLike.performanceUID!)
                        self.pathupdateDate(path: self.structLike.performancePath!)
                        self.likeupdateDate(count: self.structLike.performanceLikeCount!)
                        print(self.structLike.performanceArray!)
                        print(self.structLike.performanceUID!)
                        print(self.structLike.performancePath!)
                        print(self.structLike.performanceLikeCount!)
                        
                        self.performanceViewController?.structLike = self.structLike
                    }
                } else {
                    print("Document does not exist")
                }
            }
        } else {
            // '좋아요'를 했을 때
            //var countFavorite = 0
            for placeName in self.dicFavorite!["performanceArray"] as! NSArray {
                if let name = placeName as? String {
                    if name.count > 0 {
                        //countFavorite += 1
                    }
                }
            }
            if structLike.performanceLikeCount! >= 3 {
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
            self.structLike.performanceLikeCount! += 1
            // '좋아요'를 눌렀을 때 눌른 정보를 찜한 목록에 저장
            let docRef = db.collection("places/\(placeName)/performances").document("\(structPerf.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    if self.structLike.performanceArray![0] == "" {
                        self.structLike.performanceArray![0] = self.structPerf.title ?? "테스트1"
                        self.structLike.performanceUID![0] = self.structPerf.uid ?? "uid test1"
                        self.structLike.performancePath![0] = "places/\(self.placeName)/performances/\(self.structPerf.docID!)"
                        self.arrayupdateDate(arr: self.structLike.performanceArray!)
                        self.uidupdateDate(uid: self.structLike.performanceUID!)
                        self.pathupdateDate(path: self.structLike.performancePath!)
                        self.likeupdateDate(count: self.structLike.performanceLikeCount!)
                        print(self.structLike.performanceArray!)
                        print(self.structLike.performanceUID!)
                        print(self.structLike.performancePath!)
                        print(self.structLike.performanceLikeCount!)
                        
                        self.performanceViewController?.structLike = self.structLike
                    } else if self.structLike.performanceArray![1] == "" {
                        self.structLike.performanceArray![1] = self.structPerf.title ?? "테스트2"
                        self.structLike.performanceUID![1] = self.structPerf.uid ?? "uid test2"
                        self.structLike.performancePath![1] = "places/\(self.placeName)/performances/\(self.structPerf.docID!)"
                        self.arrayupdateDate(arr: self.structLike.performanceArray!)
                        self.uidupdateDate(uid: self.structLike.performanceUID!)
                        self.pathupdateDate(path: self.structLike.performancePath!)
                        self.likeupdateDate(count: self.structLike.performanceLikeCount!)
                        print(self.structLike.performanceArray!)
                        print(self.structLike.performanceUID!)
                        print(self.structLike.performancePath!)
                        print(self.structLike.performanceLikeCount!)
                        
                        self.performanceViewController?.structLike = self.structLike
                    } else if self.structLike.performanceArray![2] == "" {
                        self.structLike.performanceArray![2] = self.structPerf.title ?? "테스트3"
                        self.structLike.performanceUID![2] = self.structPerf.uid ?? "uid test3"
                        self.structLike.performancePath![2] = "places/\(self.placeName)/performances/\(self.structPerf.docID!)"
                        self.arrayupdateDate(arr: self.structLike.performanceArray!)
                        self.uidupdateDate(uid: self.structLike.performanceUID!)
                        self.pathupdateDate(path: self.structLike.performancePath!)
                        self.likeupdateDate(count: self.structLike.performanceLikeCount!)
                        print(self.structLike.performanceArray!)
                        print(self.structLike.performanceUID!)
                        print(self.structLike.performancePath!)
                        print(self.structLike.performanceLikeCount!)
                        
                        self.performanceViewController?.structLike = self.structLike
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
            db.collection("favorite").document("\(email)").updateData(["performanceLikeCount": count])
        }
    }
    func arrayupdateDate(arr: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["performanceArray": arr])
        }
    }
    func uidupdateDate(uid: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["performanceUID": uid])
        }
    }
    func pathupdateDate(path: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["performancePath": path])
        }
    }

    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}