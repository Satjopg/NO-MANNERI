//
//  ViewController.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/13.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var purposeField: PickerTextField!
    
    var googleMap : GMSMapView!
    // デフォルトは東京駅
    var latitude: CLLocationDegrees = 35.681298
    var longitude: CLLocationDegrees = 139.766247
    
    var locationManager: CLLocationManager?
    
    var loadview: loadviewIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // サーチバーの設定
        purposeField.setup(dataList: ["", "食事", "カフェ", "娯楽施設", "公園"])
        
        // ぐるぐるのセットアップ
        loadview = loadviewIndicator()
        loadview.setup(center: self.view.center)
        locationManager = CLLocationManager()
        
        // 位置情報の取得許可確認
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        // locationmanagerの委託を明示
        locationManager?.delegate = self
        // 一回だけ位置情報を取得できるお
        locationManager?.requestLocation()
        
        // MapViewを生成.
        googleMap = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height-45))
        
        // カメラを生成.
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: 15)
        googleMap.camera = camera
        
        // viewに追加(表示)
        self.view.addSubview(googleMap)
        self.view.addSubview(loadview)
        
        // ぐるぐるスタート
        loadview.on()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            // 取得した位置情報の更新
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            // 現在地マーカーの表示許可
            googleMap.isMyLocationEnabled = true
            
            // 現在地ボタンの追加
            googleMap.settings.myLocationButton = true
            
            // ぐるぐる停止
            loadview.off()
            
            // 現在地にカメラを移動
            googleMap.animate(toLocation: CLLocationCoordinate2DMake(latitude, longitude))
        } else {
            print("すまん, ミスった")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ミスたお")
    }
    
    //  遷移先に戻るボタンを追加する
    func add_BackBtn() {
        //      戻るボタンの設定（遷移先に表示される）
        let backbtn = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backbtn
    }
    
    // 画面遷移時の値の受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapResultsegue" {
            let nextview = segue.destination as! searchResultViewController
            nextview.latitude = Double(self.latitude)
            nextview.longitude = Double(self.longitude)
            nextview.flag = 1
            if purposeField.text != "" {
                nextview.genre = purposeField.text!
            }
        }
    }
}

