//
//  detailViewController.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/15.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit
import AlamofireImage

class detailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var reviewTabel: UITableView!
    
    var latitude:Double = 0
    var longitude:Double = 0
    var name:String = ""
    var genre:String = ""
    var rate:String = ""
    var price_rate:String = ""
    var place_id:String = ""
    var photo:String = ""
    var p_flg:Bool = true
    var reference:[String:String] = [:]
    var url:URL!
    var reviews:[[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if p_flg {
            url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?photoreference="+photo+"&maxwidth=400&key="+MY_PLACE_KEY)
        }else{
            url = URL(string:photo)
        }
        placeImage.af_setImage(withURL: url!)
        reference = detail_info(place_id: place_id)
        reviews = get_review(place_id: place_id)
        
        genreLabel.text = genre
        titleLabel.text = name
        priceLabel.text = "コスパ: "+price_rate+"/5.0"
        rateLabel.text = "評価: "+rate+"/5.0"
        adressLabel.text = "住所: "+reference["address"]!
        telLabel.text = "TEL: "+reference["phone"]!
        
        reviewTabel.estimatedRowHeight = 100
        reviewTabel.rowHeight = UITableViewAutomaticDimension
        reviewTabel.register(reviewCell.self, forCellReuseIdentifier: "rCell")
        reviewTabel.layer.borderWidth = 1
        reviewTabel.layer.borderColor = UIColor.black.cgColor
        reviewTabel.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:reviewCell = reviewTabel.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! reviewCell
        let info:[String:String] = reviews[indexPath.row]
        cell.setup(rate: "評価: "+info["rate"]!+".0/5.0", comment: info["text"]!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodetailmapSegue" {
            let nextview = segue.destination as! detailMapViewController
            nextview.latitude = latitude
            nextview.longitude = longitude
        }
    }
}
