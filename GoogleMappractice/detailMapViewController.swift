//
//  detailMapViewController.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/15.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit
import GoogleMaps

class detailMapViewController: UIViewController, CLLocationManagerDelegate{
    
    var latitude:Double = 35.681298
    var longitude:Double = 139.766247
    var locationManager: CLLocationManager?
    var googleMap : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        
        // locationmanagerの委託を明示
        locationManager?.delegate = self
        
        // MapViewを生成.
        googleMap = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height-45))
        
        // カメラを生成.
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: 15)
        googleMap.camera = camera
        
        // マーカーの生成
        let marker = GMSMarker(position:CLLocationCoordinate2DMake(latitude, longitude))
        marker.title = "ここにあるよ"
        marker.map = googleMap
        
        googleMap.isMyLocationEnabled = true
        // 現在地ボタンの追加
        googleMap.settings.myLocationButton = true
        
        self.view.addSubview(googleMap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
