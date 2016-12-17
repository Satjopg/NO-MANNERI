//
//  loadviewIndicator.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/14.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit

class loadviewIndicator: UIActivityIndicatorView {
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(center:CGPoint){
        self.frame = CGRectMake(0, 0, 50, 50)
        self.center = center
        self.hidesWhenStopped = false
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.backgroundColor = UIColor.gray
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.opacity = 0.8
        self.off()
    }
    
    func on(){
        self.startAnimating()
        self.isHidden = false
    }
    
    func off(){
        self.stopAnimating()
        self.isHidden = true
    }
    
    private func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

}
