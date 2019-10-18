//
//  DatePlaceViewController.swift
//  TeamProject
//
//  Created by 황재현 on 26/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

struct StructDatePlace {
    var image: String? = nil
    var title: String? = nil
    var contents: String? = nil
    var address: String? = nil
    var price: String? = nil
    var business: String? = nil
    var tel: String? = nil
    var parking: String? = nil
    var docID: String? = nil
    var uid: String? = nil
} 

class DatePlaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var structDP: StructDatePlace = StructDatePlace()
    var structPla: StructPlace = StructPlace()
    var structLike: StructLike = StructLike()
    var arrayDatePlace = Array<StructDatePlace>()
    var dicFavorite:[String:Any] = [String:Any]()
    
    var gradientLayer: CAGradientLayer!
    var placeName: String = ""
    
    var db: Firestore!
    let storage = Storage.storage()
    
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    // 'TableViewCell' 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDatePlace.count
    }
    
    // 'TableViewCell'이 보여줄 imageview와 label
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let structDP = self.arrayDatePlace[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.imgView.sd_setImage(with: URL(string: structDP.image!), placeholderImage: UIImage(named: "placeholder.png"))
        cell.lblTitle.text = structDP.title
        let newDPContents = structDP.contents?.replacingOccurrences(of: "\\n", with: "\n")
        cell.lblContents.text = newDPContents
        cell.lblContents.numberOfLines = 0
        cell.lblContents.lineBreakMode = .byWordWrapping
        // 간격
        cell.lblInterval.text = ""
        cell.lblInterval.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        cell.selectionStyle = .none
        
        return cell
    }
    // 'TableViewCell'의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    // 'tableviewcell'이 눌렸을 때 실행되는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<arrayDatePlace.count {
            if indexPath.row == i {
                let storyboard: UIStoryboard = self.storyboard!
                let newVC: DatePlaceInformationViewController = storyboard.instantiateViewController(withIdentifier: "DatePlaceInformationViewController") as! DatePlaceInformationViewController
                newVC.structDP = self.arrayDatePlace[indexPath.row]
                newVC.placeName = placeName
                newVC.structLike = structLike
                newVC.dicFavorite = self.dicFavorite
                newVC.datePlaceViewController = self
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFirst.text = "데이트 장소"
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = self.titleView.bounds
        gradient.colors = [UIColor(red: 0/255, green: 51/255, blue: 255/255, alpha: 1).cgColor, UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1).cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.6, 0.8]
        self.titleView.layer.addSublayer(gradient)
        imgView.image = UIImage(named: "hand.png")
        lblTitle.text = structPla.name
        lblTitle.textColor = UIColor.white

        self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        // titleView를 imgView 위에 있도록 설정
        imgView.bringSubviewToFront(titleView)
        titleView.superview?.bringSubviewToFront(titleView)
        // lblTitle을 titleView 위에 있도록 설정
        titleView.bringSubviewToFront(lblTitle)
        lblTitle.superview?.bringSubviewToFront(lblTitle)
        
        // 'tableviewcell'의 밑줄 삭제
        self.tableView.separatorStyle = .none
    }
    
    // 뷰가 나타났을 때
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        likeLoadData()
    }
    
    func likeLoadData() {
        db = Firestore.firestore()
        // 로그인한 이메일에 대한 dateplcaeArray, dateplaceUID, dateplaceLikeCount 정보를 가져옴
        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection("favorite").document("\(email)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDic = document.data() as! [String: Any]

                    print( dataDic )
                    self.dicFavorite = dataDic
                    
                    let dateplaceArray = dataDic["dateplaceArray"] as! Array<String>
                    self.structLike.dateplaceArray = dateplaceArray
                    let dateplaceUID = dataDic["dateplaceUID"] as! Array<String>
                    self.structLike.dateplaceUID = dateplaceUID
                    let dateplacePath = dataDic["dateplacePath"] as! Array<String>
                    self.structLike.dateplacePath = dateplacePath
                    let dateplaceLikeCount = dataDic["dateplaceLikeCount"] as! Int
                    self.structLike.dateplaceLikeCount = dateplaceLikeCount
                    
                    print("-----------------")
                    print(self.structLike.dateplaceArray!)
                    print(self.structLike.dateplaceUID!)
                    print(self.structLike.dateplacePath!)
                    print(self.structLike.dateplaceLikeCount!)
                    print("-----------------")
                } else {
                    print("Document does not exist")
                }
            }
        }
    }

    
    
    func loadData() {
        // arrayDatePlace의 모든 데이터 삭제
        self.arrayDatePlace.removeAll()
        
        db = Firestore.firestore()
        
        db.collection("places").order(by: "number", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let docData = document.data()
                    
                    let name = docData["name"] as? String ?? ""
                    print("name: \(name)")
                    let number = docData["number"] as? Int ?? 0
                    print("number: \(number)")
                    
                    if self.structPla.name == name {
                        let engPlaceName = document.documentID
                        
                        // 컬렉션에서 모든 문서를 읽음.
                        self.db.collection("places/\(engPlaceName)/dateplaces").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    print("\(document.documentID) => \(document.data())")
                                    let docData = document.data()
                                    
                                    let image = docData["image"] as? String ?? ""
                                    print("image: \(image)")
                                    let title = docData["title"] as? String ?? ""
                                    print("title: \(title)")
                                    let contents = docData["contents"] as? String ?? ""
                                    print("contents: \(contents)")
                                    let tel = docData["tel"] as? String ?? ""
                                    print("tel: \(tel)")
                                    let address = docData["address"] as? String ?? ""
                                    print("address: \(address)")
                                    let business = docData["business"] as? String ?? ""
                                    print("business: \(business)")
                                    let parking = docData["parking"] as? String ?? ""
                                    print("parking: \(parking)")
                                    let price = docData["price"] as? String ?? ""
                                    print("price: \(price)")
                                    let uid = docData["uid"] as? String ?? ""
                                    
                                    var structDP: StructDatePlace = StructDatePlace()
                                    structDP.image = image
                                    structDP.title = title
                                    structDP.contents = contents
                                    structDP.tel = tel
                                    structDP.address = address
                                    structDP.business = business
                                    structDP.parking = parking
                                    structDP.price = price
                                    structDP.uid = uid
                                    structDP.docID = document.documentID
                                    
                                    self.arrayDatePlace.append(structDP)
                                    self.placeName = engPlaceName
                                    
                                }
                                self.tableView.reloadData()
                            }
                        }
                        break
                    }
                }
            }
        }
    }

    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
