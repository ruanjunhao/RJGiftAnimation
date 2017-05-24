//
//  ViewController.swift
//  RJGiftAnimation
//
//  Created by ruanjh on 2017/5/24.
//  Copyright © 2017年 app. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var giftContainerView : RJGiftContainerView = RJGiftContainerView()
    
    
    @IBOutlet weak var testLabel: RJGiftDigitLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftContainerView.frame = CGRect(x: 0, y: 100, width: 250, height: 140)
        giftContainerView.backgroundColor = UIColor.lightGray
        view.addSubview(giftContainerView)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        testLabel.showDigitAnimation {
//            
//        }
        
    }
    
    
    @IBAction func gift1(_ sender: Any) {
        
        let gift1 = RJGiftModel(senderName: "coderwhy", senderURL: "icon4", giftName: "火箭", giftURL: "prop_b")
        giftContainerView.showGiftModel(gift1)
    }
   
    @IBAction func gift2(_ sender: Any) {
        let gift2 = RJGiftModel(senderName: "coder", senderURL: "icon2", giftName: "飞机", giftURL: "prop_f")
        giftContainerView.showGiftModel(gift2)
        
    }
    
    
    @IBAction func gift3(_ sender: Any) {
        let gift3 = RJGiftModel(senderName: "why", senderURL: "icon3", giftName: "跑车", giftURL: "prop_g")
        giftContainerView.showGiftModel(gift3)
        
    }

    
    
}

