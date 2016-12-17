//
//  searchViewController.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/15.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit

class searchViewController: UIViewController{
    
    // 画面の表示部品
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var purposeTextField: PickerTextField!
    @IBOutlet weak var searchButton: UIButton!
    
    // 画面の読み込みのときに実行
    override func viewDidLoad() {
        super.viewDidLoad()

        purposeTextField.setup(dataList: ["", "食事", "カフェ", "娯楽施設", "公園"])
        add_BackBtn()
        searchButton.layer.cornerRadius = 8.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapGesture(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // ボタンタップ時の動作
    @IBAction func tapsearchButton(_ sender: AnyObject) {
        if placeTextField.text == "" || purposeTextField.text == "" {
            // アラートを作成
            let alert = UIAlertController(
                title: "ちょっと待て！！",
                message: "必須項目が埋まってませんよ！！",
                preferredStyle: .alert)
        
            // アラートにボタンをつける
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //  遷移先に戻るボタンを追加する
    func add_BackBtn() {
        //      戻るボタンの設定（遷移先に表示される）
        let backbtn = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backbtn
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromsearchViewSegue" {
            let nextview = segue.destination as! searchResultViewController
            nextview.flag = 2
            if placeTextField.text != "" {
                nextview.key = placeTextField.text!
            }
            if placeTextField.text != "" {
                nextview.genre = purposeTextField.text!
            }
        }
    }
}
