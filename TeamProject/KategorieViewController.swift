//
//  MenuViewController.swift
//  TeamProject
//
//  Created by 조정현 on 27/07/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase

class KategorieViewController: UIViewController {
    
    var index: Int = 0
    var place: Array<String> = []
    var db: Firestore!
    var arrayPlaces = Array<StructPlace>()
    var structPla: StructPlace = StructPlace()

    
    @IBOutlet weak var dateplacesView: UIView!
    @IBOutlet weak var performancesView: UIView!
    @IBOutlet weak var foodcafeView: UIView!
    @IBOutlet weak var moviesView: UIView!
    
    @IBOutlet weak var lblPlace: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPlace.text = structPla.name
        
        dateplacesView.backgroundColor = UIColor(red: 182/255, green: 236/255, blue: 253/255, alpha: 1)
        dateplacesView.layer.cornerRadius = 20.0
        dateplacesView.layer.shadowPath =
            UIBezierPath(roundedRect: self.dateplacesView.bounds,
                         cornerRadius: self.dateplacesView.layer.cornerRadius).cgPath
        dateplacesView.layer.shadowColor = UIColor.black.cgColor
        dateplacesView.layer.shadowOpacity = 0.5
        dateplacesView.layer.shadowOffset = CGSize(width: 5, height: 5)
        dateplacesView.layer.shadowRadius = 1
        dateplacesView.layer.masksToBounds = false
        
        performancesView.backgroundColor = UIColor(red: 162/255, green: 217/255, blue: 251/255, alpha: 1)
        performancesView.layer.cornerRadius = 20.0
        performancesView.layer.shadowPath =
            UIBezierPath(roundedRect: self.performancesView.bounds,
                         cornerRadius: self.performancesView.layer.cornerRadius).cgPath
        performancesView.layer.shadowColor = UIColor.black.cgColor
        performancesView.layer.shadowOpacity = 0.5
        performancesView.layer.shadowOffset = CGSize(width: 5, height: 5)
        performancesView.layer.shadowRadius = 1
        performancesView.layer.masksToBounds = false
        
        foodcafeView.backgroundColor = UIColor(red: 110/255, green: 193/255, blue: 249/255, alpha: 1)
        foodcafeView.layer.cornerRadius = 20.0
        foodcafeView.layer.shadowPath =
            UIBezierPath(roundedRect: self.foodcafeView.bounds,
                         cornerRadius: self.foodcafeView.layer.cornerRadius).cgPath
        foodcafeView.layer.shadowColor = UIColor.black.cgColor
        foodcafeView.layer.shadowOpacity = 0.5
        foodcafeView.layer.shadowOffset = CGSize(width: 5, height: 5)
        foodcafeView.layer.shadowRadius = 1
        foodcafeView.layer.masksToBounds = false
        
        moviesView.backgroundColor = UIColor(red: 65/255, green: 145/255, blue: 247/255, alpha: 1)
        moviesView.layer.cornerRadius = 20.0
        moviesView.layer.shadowPath =
            UIBezierPath(roundedRect: self.moviesView.bounds,
                         cornerRadius: self.moviesView.layer.cornerRadius).cgPath
        moviesView.layer.shadowColor = UIColor.black.cgColor
        moviesView.layer.shadowOpacity = 0.5
        moviesView.layer.shadowOffset = CGSize(width: 5, height: 5)
        moviesView.layer.shadowRadius = 1
        moviesView.layer.masksToBounds = false
    }
    
    // 데이트 장소
    @IBAction func btnDatePlace(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: DatePlaceViewController = storyboard.instantiateViewController(withIdentifier: "DatePlaceViewController") as! DatePlaceViewController
        newVC.structPla = structPla
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // 공연/전시
    @IBAction func btnPerformance(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: PerformanceViewController = storyboard.instantiateViewController(withIdentifier: "PerformanceViewController") as! PerformanceViewController
        newVC.structPla = structPla
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // 맛집/카페
    @IBAction func btnFoodCafe(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: FoodCafeViewController = storyboard.instantiateViewController(withIdentifier: "FoodCafeViewController") as! FoodCafeViewController
        newVC.structPla = structPla
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // 영화
    @IBAction func btnMovie(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as UIViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // 뒤로가기
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
