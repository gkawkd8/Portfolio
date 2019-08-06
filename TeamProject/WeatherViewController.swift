//
//  WeatherViewController.swift
//  TeamProject
//
//  Created by 조정현 on 06/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "2f4908df169882092ef2cb291b3ab7d1"
    var lat = 11.344533
    var lon = 104.33322
    var activityIndicator:NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize:CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2,y:(view.frame.height-indicatorSize)/2,width: indicatorSize,height:indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON{
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setGreyGradientBackground()
                }else{
                    self.setBlueGradientBackground()
                }
                
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manger: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0,green: 165.0/255.0,blue:1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red:72.0/255.0, green:  114.0/255.0, blue: 184.0/255.0,alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor,bottomColor]
        
    }
    func setGreyGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0,green: 151.0/255.0,blue:151.0/1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red:72.0/255.0, green:72.0/255.0, blue: 72.0/255.0,alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor,bottomColor]
        
    }
}
