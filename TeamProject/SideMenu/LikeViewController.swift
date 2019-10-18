//
//  LikeViewController.swift
//  TeamProject
//
//  Created by 황재현 on 06/09/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class LikeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewData = [cellData]()
    
    var structPla: StructPlace = StructPlace()
    var structDP: StructDatePlace = StructDatePlace()
    var structPerf: StructPerformance = StructPerformance()
    var structFC: StructFoodCafe = StructFoodCafe()
    var structMovie: StructMovie = StructMovie()
    var structLike: StructLike = StructLike()
    var dicFavorite:[String:Any]? = nil
    
    var db: Firestore!
    var placeName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likeLoadData()
    }
    
    func likeLoadData() {
        db = Firestore.firestore()
        // 로그인한 이메일에 대한 저장한 목록 정보를 가져옴
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
                    
                    let performanceArray = dataDic["performanceArray"] as! Array<String>
                    self.structLike.performanceArray = performanceArray
                    let performanceUID = dataDic["performanceUID"] as! Array<String>
                    self.structLike.performanceUID = performanceUID
                    let performancePath = dataDic["performancePath"] as! Array<String>
                    self.structLike.performancePath = performancePath
                    let performanceLikeCount = dataDic["performanceLikeCount"] as! Int
                    self.structLike.performanceLikeCount = performanceLikeCount
                    
                    let foodcafeArray = dataDic["foodcafeArray"] as! Array<String>
                    self.structLike.foodcafeArray = foodcafeArray
                    let foodcafeUID = dataDic["foodcafeUID"] as! Array<String>
                    self.structLike.foodcafeUID = foodcafeUID
                    let foodcafePath = dataDic["foodcafePath"] as! Array<String>
                    self.structLike.foodcafePath = foodcafePath
                    let foodcafeLikeCount = dataDic["foodcafeLikeCount"] as! Int
                    self.structLike.foodcafeLikeCount = foodcafeLikeCount
                    
                    let movieArray = dataDic["movieArray"] as! Array<String>
                    self.structLike.movieArray = movieArray
                    let movieUID = dataDic["movieUID"] as! Array<String>
                    self.structLike.movieUID = movieUID
                    let moviePath = dataDic["moviePath"] as! Array<String>
                    self.structLike.moviePath = moviePath
                    let movieLikeCount = dataDic["movieLikeCount"] as! Int
                    self.structLike.movieLikeCount = movieLikeCount
                    
                    print("-----------------")
                    print(self.structLike.dateplaceArray!)
                    print(self.structLike.dateplaceUID!)
                    print(self.structLike.dateplacePath!)
                    print(self.structLike.dateplaceLikeCount!)
                    
                    print(self.structLike.performanceArray!)
                    print(self.structLike.performanceUID!)
                    print(self.structLike.performancePath!)
                    print(self.structLike.performanceLikeCount!)
                    
                    print(self.structLike.foodcafeArray!)
                    print(self.structLike.foodcafeUID!)
                    print(self.structLike.foodcafePath!)
                    print(self.structLike.foodcafeLikeCount!)
                    
                    print(self.structLike.movieArray!)
                    print(self.structLike.movieUID!)
                    print(self.structLike.moviePath!)
                    print(self.structLike.movieLikeCount!)

                    print("-----------------")
                } else {
                    print("Document does not exist")
                }
            }
        }
        tableViewData = [cellData(opened: false, title: "데이트 장소", sectionData: ["\(structLike.dateplaceArray![0])", "\(structLike.dateplaceArray![1])", "\(structLike.dateplaceArray![2])"]),
                         cellData(opened: false, title: "공연/전시", sectionData: ["\(structLike.performanceArray![0])", "\(structLike.performanceArray![1])", "\(structLike.performanceArray![2])"]),
                         cellData(opened: false, title: "맛집/카페", sectionData: ["\(structLike.foodcafeArray![0])", "\(structLike.foodcafeArray![1])", "\(structLike.foodcafeArray![2])"]),
                         cellData(opened: false, title: "최신영화", sectionData: ["\(structLike.movieArray![0])", "\(structLike.movieArray![1])", "\(structLike.movieArray![2])"])]
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections:", tableViewData.count)
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            //print("numberOfRowsInSection:", section, tableViewData[section].sectionData.count + 1)
            return tableViewData[section].sectionData.count + 1
        } else {
            //print("numberOfRowsInSection:", section, 1)
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") else {return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.backgroundColor = UIColor(red: 019/255, green: 073/255, blue: 183/255, alpha: 1)
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            return cell
        } else {
            // Use different cell identifier if needed
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") else {return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            return cell
        }
    }
    // 'tableviewcell'이 눌렸을 때 실행되는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath:",indexPath)
        if indexPath.row == 0 { // 카테고리를 닫을 때
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none) // play around with this
                print("카테고리 닫기")
            } else { // 카테고리를 열 때
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none) // play around with this
                print("카테고리 열기")
            }
        } else {
            let section = indexPath.section // 카테고리
            let row = indexPath.row // 저장한 목록
            if section == 0 { // 데이트 장소
                // 선택한 장소가 있는 경우
                if structLike.dateplaceArray![row-1] != "" {
                    let path = structLike.dateplacePath![row-1]
                    // structLike.dateplacePath![row-1] 값을 "/" 단위로 1개씩 끊어서 배열로 만듬
                    let arrayPath = path.split(separator: "/")
                    // 선택한 장소에 대한 데이터베이스를 가져옴.
                    self.db.collection(String(arrayPath[0])).document(String(arrayPath[1])).collection(String(arrayPath[2])).document(String(arrayPath[3])).getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("\(document.documentID) => \(document.data())")
                            let docData = document.data()
                            let image = docData!["image"] as? String ?? ""
                            let title = docData!["title"] as? String ?? ""
                            let contents = docData!["contents"] as? String ?? ""
                            let tel = docData!["tel"] as? String ?? ""
                            let address = docData!["address"] as? String ?? ""
                            let business = docData!["business"] as? String ?? ""
                            let parking = docData!["parking"] as? String ?? ""
                            let price = docData!["price"] as? String ?? ""
                            let uid = docData!["uid"] as? String ?? ""
                            
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
                            self.placeName = String(arrayPath[1])
                            
                            let storyboard: UIStoryboard = self.storyboard!
                            let newVC: DatePlaceInformationViewController = storyboard.instantiateViewController(withIdentifier: "DatePlaceInformationViewController") as! DatePlaceInformationViewController
                            // 데이터를 넘어갈 화면에 넘김
                            newVC.structDP = structDP
                            newVC.structLike = self.structLike
                            newVC.placeName = self.placeName
                            newVC.dicFavorite = self.dicFavorite
                            self.navigationController?.pushViewController(newVC, animated: true)
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            } else if section == 1 { // 공연/전시
                // 선택한 장소가 있는 경우
                if structLike.performanceArray![row-1] != "" {
                    let path = structLike.performancePath![row-1]
                    // structLike.performancePath![row-1] 값을 / 단위로 1개씩 끊어서 배열로 만듬
                    let arrayPath = path.split(separator: "/")
                    
                    // 선택한 장소에 대한 데이터베이스를 가져옴.
                    self.db.collection(String(arrayPath[0])).document(String(arrayPath[1])).collection(String(arrayPath[2])).document(String(arrayPath[3])).getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("\(document.documentID) => \(document.data())")
                            let docData = document.data()
                            
                            let image = docData!["image"] as? String ?? ""
                            print("image: \(image)")
                            let title = docData!["title"] as? String ?? ""
                            print("title: \(title)")
                            let contents = docData!["contents"] as? String ?? ""
                            print("contents: \(contents)")
                            let tel = docData!["tel"] as? String ?? ""
                            print("tel: \(tel)")
                            let address = docData!["address"] as? String ?? ""
                            print("address: \(address)")
                            let business = docData!["business"] as? String ?? ""
                            print("business: \(business)")
                            let parking = docData!["parking"] as? String ?? ""
                            print("parking: \(parking)")
                            let price = docData!["price"] as? String ?? ""
                            print("price: \(price)")
                            let uid = docData!["uid"] as? String ?? ""
                            
                            var structPerf: StructPerformance = StructPerformance()
                            structPerf.image = image
                            structPerf.title = title
                            structPerf.contents = contents
                            structPerf.tel = tel
                            structPerf.address = address
                            structPerf.business = business
                            structPerf.parking = parking
                            structPerf.price = price
                            structPerf.uid = uid
                            structPerf.docID = document.documentID
                            
                            self.placeName = String(arrayPath[1])
                            
                            let storyboard: UIStoryboard = self.storyboard!
                            let newVC: PerformanceInformationViewController = storyboard.instantiateViewController(withIdentifier: "PerformanceInformationViewController") as! PerformanceInformationViewController
                            // 데이터를 넘어갈 화면에 넘김
                            newVC.structPerf = structPerf
                            newVC.structLike = self.structLike
                            newVC.placeName = self.placeName
                            newVC.dicFavorite = self.dicFavorite
                            self.navigationController?.pushViewController(newVC, animated: true)
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            } else if section == 2 { // 맛집/카페
                // 선택한 장소가 있는 경우
                if structLike.foodcafeArray![row-1] != "" {
                    let path = structLike.foodcafePath![row-1]
                    // structLike.foodcafePath![row-1] 값을 "/" 단위로 1개씩 끊어서 배열로 만듬
                    let arrayPath = path.split(separator: "/")
                    
                    // 선택한 장소에 대한 데이터베이스를 가져옴.
                    self.db.collection(String(arrayPath[0])).document(String(arrayPath[1])).collection(String(arrayPath[2])).document(String(arrayPath[3])).getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("\(document.documentID) => \(document.data())")
                            let docData = document.data()
                            
                            let image = docData!["image"] as? String ?? ""
                            print("image: \(image)")
                            let title = docData!["title"] as? String ?? ""
                            print("title: \(title)")
                            let contents = docData!["contents"] as? String ?? ""
                            print("contents: \(contents)")
                            let tel = docData!["tel"] as? String ?? ""
                            print("tel: \(tel)")
                            let address = docData!["address"] as? String ?? ""
                            print("address: \(address)")
                            let business = docData!["business"] as? String ?? ""
                            print("business: \(business)")
                            let parking = docData!["parking"] as? String ?? ""
                            print("parking: \(parking)")
                            let price = docData!["price"] as? String ?? ""
                            print("price: \(price)")
                            let uid = docData!["uid"] as? String ?? ""
                            let pageimage = docData!["pageimage"] as? Array<String> ?? [""]
                            print("pageimage: \(pageimage)")
                            
                            var structFC: StructFoodCafe = StructFoodCafe()
                            structFC.image = image
                            structFC.title = title
                            structFC.contents = contents
                            structFC.tel = tel
                            structFC.address = address
                            structFC.business = business
                            structFC.parking = parking
                            structFC.price = price
                            structFC.uid = uid
                            structFC.docID = document.documentID
                            structFC.pageimage = pageimage
                            
                            self.placeName = String(arrayPath[1])
                            
                            let storyboard: UIStoryboard = self.storyboard!
                            let newVC: FoodCafePageViewController = storyboard.instantiateViewController(withIdentifier: "FoodCafePageViewController") as! FoodCafePageViewController
                            // 데이터를 넘어갈 화면에 넘김
                            newVC.structFC = structFC
                            newVC.structLike = self.structLike
                            newVC.placeName = self.placeName
                            newVC.dicFavorite = self.dicFavorite!
                            self.navigationController?.pushViewController(newVC, animated: true)
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            } else if section == 3 { // 최신영화
                // 선택한 장소가 있는 경우
                if structLike.movieArray![row-1] != "" {
                    let path = structLike.moviePath![row-1]
                    // structLike.moviePath![row-1] 값을 "/" 단위로 1개씩 끊어서 배열로 만듬
                    let arrayPath = path.split(separator: "/")
                    // 선택한 장소에 대한 데이터베이스를 가져옴.
                    
                    self.db.collection(String(arrayPath[0])).document(String(arrayPath[1])).getDocument { (document, error) in 
                        if let document = document, document.exists {
                            print("\(document.documentID) => \(document.data())")
                            let docData = document.data()
                            
                            let movieTitle = docData!["movieTitle"] as? String ?? ""
                            print("movieTitle: \(movieTitle)")
                            let movieImg = docData!["movieImg"] as? String ?? ""
                            print("movieImg: \(movieImg)")
                            let movieSummary = docData!["movieSummary"] as? String ?? ""
                            print("movieSummary: \(movieSummary)")
                            let movieReadRole = docData!["movieReadRole"] as? String ?? ""
                            print("movieReadRole: \(movieReadRole)")
                            let movieDirector = docData!["movieDirector"] as? String ?? ""
                            print("movieDirector: \(movieDirector)")
                            let movieNaver = docData!["movieNaver"] as? String ?? ""
                            print("movieNaver: \(movieNaver)")
                            let movieLotte = docData!["movieLotte"] as? String ?? ""
                            print("movieLotte: \(movieLotte)")
                            let movieCGV = docData!["movieCGV"] as? String ?? ""
                            print("movieCGV: \(movieCGV)")
                            let movieMega = docData!["movieMega"] as? String ?? ""
                            print("movieMega: \(movieMega)")
                            let uid = docData!["uid"] as? String ?? ""
                            
                            var structMovie: StructMovie = StructMovie()
                            structMovie.movieTitle = movieTitle
                            structMovie.movieImg = movieImg
                            structMovie.movieSummary = movieSummary
                            structMovie.movieReadRole = movieReadRole
                            structMovie.movieDirector = movieDirector
                            structMovie.movieNaver = movieNaver
                            structMovie.movieLotte = movieLotte
                            structMovie.movieCGV = movieCGV
                            structMovie.movieMega = movieMega
                            structMovie.uid = uid
                            structMovie.docID = document.documentID
                            
                            self.placeName = String(arrayPath[1])
                            
                            let storyboard: UIStoryboard = self.storyboard!
                            let newVC: MovieInformationViewController = storyboard.instantiateViewController(withIdentifier: "MovieInformationViewController") as! MovieInformationViewController
                            // 데이터를 넘어갈 화면에 넘김
                            newVC.structMovie = structMovie
                            newVC.structLike = self.structLike
                            //newVC.placeName = self.placeName
                            newVC.dicFavorite = self.dicFavorite
                            self.navigationController?.pushViewController(newVC, animated: true)
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
