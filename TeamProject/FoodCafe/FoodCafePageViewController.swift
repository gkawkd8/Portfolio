//
//  FoodCafePageViewController.swift
//  TeamProject
//
//  Created by 황재현 on 29/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import Parchment
import SDWebImage

class FoodCafePageViewController: UIViewController {
    var foodCafeViewController: FoodCafeViewController? = nil
    var structFC: StructFoodCafe = StructFoodCafe()
    var structLike: StructLike = StructLike()
    var dicFavorite:[String:Any] = [String:Any]()
    
    var placeName: String = ""
    var db: Firestore!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let PageChangeViewController = storyboard.instantiateViewController(withIdentifier: "PageChangeViewController") as! PageChangeViewController
        // PageChangeViewController로 structFC에 대한 데이터를 넘겨줌
        PageChangeViewController.structFC = self.structFC
        
        let FoodCafeInformationViewController = storyboard.instantiateViewController(withIdentifier:"FoodCafeInformationViewController") as! FoodCafeInformationViewController
        // FoodCafeInformationViewController로 structFC에 대한 데이터를 넘겨줌
        FoodCafeInformationViewController.structFC = self.structFC
        FoodCafeInformationViewController.placeName = placeName
        FoodCafeInformationViewController.structLike = structLike
        FoodCafeInformationViewController.dicFavorite = self.dicFavorite
        FoodCafeInformationViewController.foodCafeViewController = self.foodCafeViewController
        
        let pagingViewController = FixedPagingViewController(viewControllers: [
            FoodCafeInformationViewController,
            PageChangeViewController,
            ])

        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges2(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
        
}
