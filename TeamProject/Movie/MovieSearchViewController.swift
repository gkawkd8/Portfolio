//
//  MovieSearchViewController.swift
//  Travel
//
//  Created by 황재현 on 29/07/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class MovieSearchViewController: UIViewController {
    var db: Firestore!
    var structMovie: StructMovie? = nil
    var arrayMovie = Array<StructMovie>()
    
    var index: Int = 0

    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        lblFirst.text = structMovie?.movieTitle
        let logoutAlert = UIAlertController(title: "\(structMovie?.movieTitle ?? "")", message: "홈페이지를 눌러 영화를 예매하세요.", preferredStyle: UIAlertController.Style.alert)
        let noAlert = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        logoutAlert.addAction(noAlert)
        
        present(logoutAlert, animated: true, completion: nil)
        //print(arrayMovie.count)
    }
    
    func loadWebPage(_ url: String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
    }
    @IBAction func btnNaver(_ sender: UIButton) {
        for i in 0...10 {
            if index == i {
                loadWebPage(structMovie?.movieNaver ?? "")
            }
        }
    }
    @IBAction func btnMega(_ sender: UIButton) {
        for i in 0...10 {
            if index == i {
                loadWebPage(structMovie?.movieMega ?? "")
            }
        }
    }
    @IBAction func btnLotte(_ sender: UIButton) {
        for i in 0...10 {
            if index == i {
                loadWebPage(structMovie?.movieLotte ?? "")
            }
        }
    }
    @IBAction func btnCGV(_ sender: UIButton) {
        for i in 0...10 {
            if index == i {
                loadWebPage(structMovie?.movieCGV ?? "")
            }
        }
    }
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// 사자0, 라이온킹1, 나랏말싸미2, 엑시트3, 알라딘4, 스파이더맨5, 봉오동6, 롱샷7, 토이스토리8, 마이펫9
