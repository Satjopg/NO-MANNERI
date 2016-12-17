//
//  searchResultViewController.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/15.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit
import AlamofireImage

class searchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var resultTable: UITableView!
    var data:[[String:String]] = []
    var latitude:Double = 0
    var longitude:Double = 0
    var genre:String = ""
    var flag:Int = 1
    var key:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch flag {
        case 1:
            data = place_easy_info(latitude: latitude, longitude:longitude, genre: genre)
        case 2:
            data = free_word_search(key: key, genre: genre)
        default:break
        }
        
        resultTable.estimatedRowHeight = 10000
        resultTable.rowHeight = UITableViewAutomaticDimension
        resultTable.register(resultCell.self, forCellReuseIdentifier: "cell")
        
        add_BackBtn()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  遷移先に戻るボタンを追加する
    func add_BackBtn() {
        //      戻るボタンの設定（遷移先に表示される）
        let backbtn = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backbtn
    }
    
    // 生成するcellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! resultCell
        let info = data[indexPath.row]
        cell.setup(genre: info["genre"]!, place:info["name"]!, rate: "みんなの評価:"+info["rate"]!+"/5.0", price: "コスパ:"+info["price"]!+"/5.0")
        let url = URL(string: info["icon"]!)
        cell.iconImage.af_setImage(withURL: url!)
        return cell
    }
    
    // 値の受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodetailSegue" {
            let index = resultTable.indexPathForSelectedRow?.item
            let info:[String:String] = data[index!]
            let nextView = segue.destination as! detailViewController
            nextView.genre = info["genre"]!
            nextView.name = info["name"]!
            nextView.price_rate = info["price"]!
            nextView.rate = info["rate"]!
            nextView.latitude = Double(info["latitude"]!)!
            nextView.longitude = Double(info["longitude"]!)!
            nextView.place_id = info["place_id"]!
            if info["photo"] != "icon"{
                nextView.photo = info["photo"]!
            } else {
                nextView.photo = info["icon"]!
                nextView.p_flg = false
            }
        }
    }
}
