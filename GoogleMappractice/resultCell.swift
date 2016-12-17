//
//  resultCell.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/15.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit

class resultCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    func setup(genre:String, place:String, rate:String, price:String){
        genreLabel.text = genre
        placeLabel.text = place
        rateLabel.text = rate
        priceLabel.text = price
    }
}
