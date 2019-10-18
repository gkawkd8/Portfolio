//
//  MapViewController.swift
//  TeamProject
//
//  Created by 조정현 on 30/07/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit
import GoogleMaps
import MarqueeLabel
import Firebase

struct StructPlace {
    var name: String? = nil
    var number: Int? = 0
}

class MainViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var arrayPlaces = Array<StructPlace>()

    @IBOutlet weak var marqueeLabel: MarqueeLabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var btnPlaces: [UIButton]!
    
    var db: Firestore!

    var max: Int = 28
    
//    은평 0 / 종로 1 / 대학로 2 / 삼청동 3 / 강북 4 / 노윈 5 / 신촌 6 / 광화문 7 / 중구 8 / 동대문 9
//    광진 10 / 마포 11 / 홍대 12 / 명동 13 / 건대 14 / 합정 15 / 용산 16 / 이태원 17 / 강서 18 / 영등포 19
//    동작 20 / 서초 21 / 가로수길 22 / 강남 23 / 강동 24 / 구로 25 / 관악 26 / 강남역 27 / 송파 28
    let locationManager = CLLocationManager()
    var myMarker = GMSMarker()
    var lengthyLabel = MarqueeLabel.init(frame: accessibilityFrame(), duration: 8.0, fadeLength: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        // 컬렉션에서 모든 문서를 읽음.
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
                    
                    var structPla: StructPlace = StructPlace()
                    structPla.name = name
                    structPla.number = number
                    
                    self.arrayPlaces.append(structPla)
                }
            }
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        marqueeLabel.type = .continuous
        marqueeLabel.scrollDuration = 20.0
        marqueeLabel.animationCurve = .linear
        marqueeLabel.fadeLength = 100.0
        marqueeLabel.leadingBuffer = 0.0
        marqueeLabel.trailingBuffer = 0.0
        marqueeLabel.animationDelay = 0
        marqueeLabel.backgroundColor = UIColor(red: 51/255, green: 153/255, blue: 255/255, alpha: 1)
        marqueeLabel.textColor = UIColor.white
        
        self.marqueeLabel.text = "서울지역에서 사랑하는 연인끼리 할 수 있는 다양한 정보를 제공해주는 With You입니다.    많은 이용 바랍니다~"
        
        // 버튼 텍스트 숨김
        for i in 0...max {
            btnPlaces[i].setTitleColor(UIColor.clear, for: .normal)
            
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainViewController = self
    }
    
    @IBAction func btnWhere(_ sender: UIButton) {
        let btnIndex: Int = getButtonIndex(btn: sender)
        
        for structPlace in arrayPlaces {
            if( structPlace.number! == btnIndex ){
                let storyboard: UIStoryboard = self.storyboard!
                let newVC: KategorieViewController = storyboard.instantiateViewController(withIdentifier: "KategorieViewController") as! KategorieViewController
                newVC.structPla = self.arrayPlaces[btnIndex]
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
        
    }
    // 버튼값을 Int로 변환 함수
    func getButtonIndex(btn: UIButton) -> Int {
        for index in 0...max {
            if btn == btnPlaces[index] {
                return index
            }
        }
        return 0
    }
    
    // 사이드메뉴 로그아웃 버튼 눌렀을 때 화면이동
    func viewLogOut() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if(aViewController is LoginViewController){
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }
        move(at: firstLocation.coordinate)
    }
    
    func move(at coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else {
            return
        }
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        mapView.camera = camera
        
        //myMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        myMarker.map = mapView
    }
}
