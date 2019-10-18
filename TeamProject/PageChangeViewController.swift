//
//  PageChangeViewController.swift
//  TeamProject
//
//  Created by 황재현 on 30/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class PageChangeViewController: UIViewController {
    var structFC: StructFoodCafe = StructFoodCafe()
    
    var db: Firestore!
    let storage = Storage.storage()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pageControl 페이지 갯수
        pageControl.numberOfPages = structFC.pageimage!.count
        // pageControl 첫번째 페이지
        pageControl.currentPage = 0
        // pageControl 표시 색상
        pageControl.pageIndicatorTintColor = UIColor.black
        // pageControl 선택된 표시 색상
        pageControl.currentPageIndicatorTintColor = UIColor.red
        imgView.sd_setImage(with: URL(string: structFC.pageimage![0]), placeholderImage: UIImage(named: "placeholder.png"))
    }
    
    @IBAction func pageChange(_ sender: UIPageControl) {
        imgView.sd_setImage(with: URL(string: structFC.pageimage![pageControl.currentPage]), placeholderImage: UIImage(named: "placeholder.png"))
    }
}
