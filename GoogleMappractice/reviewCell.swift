//
//  reviewCell.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/15.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit

class reviewCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func setup(rate:String, comment:String){
        rateLabel.text = rate
        commentLabel.text = comment
    }

}
