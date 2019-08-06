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

class MainViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var marqueeLabel: MarqueeLabel!
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var myMarker = GMSMarker()
//    var lengthyLabel = UILabel.init(frame: accessibilityFrame())
    var lengthyLabel = MarqueeLabel.init(frame: accessibilityFrame(), duration: 8.0, fadeLength: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        marqueeLabel.type = .continuous
        marqueeLabel.scrollDuration = 18.0
        marqueeLabel.animationCurve = .linear
        marqueeLabel.fadeLength = 80.0
        marqueeLabel.leadingBuffer = 0.0
        marqueeLabel.trailingBuffer = 0.0
        marqueeLabel.animationDelay = 0
        
        self.marqueeLabel.text = "테스트 중입니다 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    }
    
    func viewLogOut() {
        self.navigationController?.popToRootViewController(animated: true)
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
        
        myMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        myMarker.map = mapView
    }
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "KategorieView", sender: self)

    }

}
