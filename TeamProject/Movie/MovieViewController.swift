//
//  MovieViewController.swift
//  Travel
//
//  Created by TJ on 25/07/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

struct StructMovie {
    var movieTitle: String? = nil
    var movieImg: String? = nil
    var movieDirector: String? = nil
    var movieReadRole: String? = nil
    var movieSummary: String? = nil
    var movieNaver: String? = nil
    var movieLotte: String? = nil
    var movieCGV: String? = nil
    var movieMega: String? = nil
    var docID: String? = nil
    var uid: String? = nil
}

class MovieViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout {
    //var structMovie: StructMovie = StructMovie()
    var structLike: StructLike = StructLike()
    var arrayMovie = Array<StructMovie>()
    var dicFavorite:[String:Any] = [String:Any]()
    
    var db: Firestore!
    let storage = Storage.storage()
    var tableNumber: Int = 0

    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 이미지 사진 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMovie.count
    }
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let structMovie = self.arrayMovie[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CollectionViewCell
                cell.imgView.sd_setImage(with: URL(string: structMovie.movieImg!), placeholderImage: UIImage(named: "placeholder.png"))
        cell.lblTitle.text = structMovie.movieTitle
        return cell
    }
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewCellWidth = collectionView.frame.width / 2-1
        return CGSize(width: collectionViewCellWidth, height: collectionViewCellWidth)
    }
    // 위 아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    // 옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    // 보여질 때 액션함수 추가
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    // 눌렀을 때 실행 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...arrayMovie.count {
            if indexPath.row == i {
                tableNumber = indexPath.row
                let storyboard: UIStoryboard = self.storyboard!
                let newVC: MovieInformationViewController = storyboard.instantiateViewController(withIdentifier: "MovieInformationViewController") as! MovieInformationViewController
                newVC.structMovie = self.arrayMovie[indexPath.row]
                newVC.index = tableNumber
                newVC.structLike = structLike
                newVC.dicFavorite = self.dicFavorite
                newVC.movieViewController = self

                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFirst.text = "최신영화"
        
        self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    }
    
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

                    let movieArray = dataDic["movieArray"] as! Array<String>
                    self.structLike.movieArray = movieArray
                    let movieUID = dataDic["movieUID"] as! Array<String>
                    self.structLike.movieUID = movieUID
                    let moviePath = dataDic["moviePath"] as! Array<String>
                    self.structLike.moviePath = moviePath
                    let movieLikeCount = dataDic["movieLikeCount"] as! Int
                    self.structLike.movieLikeCount = movieLikeCount
                    
                    print("-----------------")
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
    }
    
    func loadData() {
        self.arrayMovie.removeAll()
        
        db = Firestore.firestore()
        
        // 컬렉션에서 모든 문서를 읽음.
        db.collection("movies").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let docData = document.data()
                    
                    let movieTitle = docData["movieTitle"] as? String ?? ""
                    print("movieTitle: \(movieTitle)")
                    let movieImg = docData["movieImg"] as? String ?? ""
                    print("movieImg: \(movieImg)")
                    let movieSummary = docData["movieSummary"] as? String ?? ""
                    print("movieSummary: \(movieSummary)")
                    let movieReadRole = docData["movieReadRole"] as? String ?? ""
                    print("movieReadRole: \(movieReadRole)")
                    let movieDirector = docData["movieDirector"] as? String ?? ""
                    print("movieDirector: \(movieDirector)")
                    let movieNaver = docData["movieNaver"] as? String ?? ""
                    print("movieNaver: \(movieNaver)")
                    let movieLotte = docData["movieLotte"] as? String ?? ""
                    print("movieLotte: \(movieLotte)")
                    let movieCGV = docData["movieCGV"] as? String ?? ""
                    print("movieCGV: \(movieCGV)")
                    let movieMega = docData["movieMega"] as? String ?? ""
                    print("movieMega: \(movieMega)")
                    let uid = docData["uid"] as? String ?? ""
                    
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
                    
                    self.arrayMovie.append(structMovie)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
//        for i in 0...movieTitle.count {
//            if indexPath.row == i {
//                let storyboard: UIStoryboard = self.storyboard!
//                let newVC: MovieSearchViewController = storyboard.instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
//                newVC.movie = images
//                newVC.name = movieTitle
//                newVC.index = tableNumber
//
//                self.navigationController?.pushViewController(newVC, animated: true)
//                tableNumber = indexPath.row
//            }
//        }
    
    // --------------------------------------------------
    // 'tableviewcell' 갯수
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return movieTitle.count
//    }
//    // 'tableviewcell'이 보여줄 imageview와 label
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//        cell.imgView.image = UIImage(named: images[indexPath.row])
//        cell.lblTitle.text = movieTitle[indexPath.row]
//        return cell
//    }
//    // 'tableViewcell'이 보여질 때 액션 추가
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
////        cell.layer.transform = rotationTransform
////        cell.alpha = 0.5
////
////        UIView.animate(withDuration: 1.0) {
////            cell.layer.transform = CATransform3DIdentity
////            cell.alpha = 1.0
////        }
//        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
//        cell.layer.transform = rotationTransform
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.75) {
//            cell.layer.transform = CATransform3DIdentity
//            cell.alpha = 1.0
//        }
//    }
//    // 'tableviewcell'의 높이
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
//    // 'tableviewcell'이 눌렸을 때 실행되는 함수
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        for i in 0...movieTitle.count {
//            if indexPath.row == i {
//                let storyboard: UIStoryboard = self.storyboard!
//                let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "MovieSearchViewController") as UIViewController
//
//                self.navigationController?.pushViewController(newVC, animated: true)
//                tableNumber = indexPath.row
//            }
//        }
//    }
    // ----------------------------------------------------------------
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
