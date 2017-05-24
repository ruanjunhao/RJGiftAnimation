//
//  RJGiftDigitLabel.swift
//  RJGiftAnimation
//
//  Created by ruanjh on 2017/5/24.
//  Copyright © 2017年 app. All rights reserved.
//

import UIKit

class RJGiftDigitLabel: UILabel {

   
    override func draw(_ rect: CGRect) {
        
        //获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        
        //画出第一层文字
        ctx?.setTextDrawingMode(.stroke)
        ctx?.setLineWidth(5.0)
       // ctx?.setLineCap(.round)
        ctx?.setLineJoin(.round)
        textColor = UIColor.orange
        super.draw(rect)
        
        //画出第二层文字
        ctx?.setTextDrawingMode(.fill)
        //ctx?.setLineWidth(2.0)
        textColor = UIColor.white
        super.draw(rect)
        
    }
    
    //闭包逃逸
    func showDigitAnimation(_ completion : @escaping ()->())  {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: { 
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })

            
            
        }, completion: { (isFinished) in
        
            //尾随闭包的写法
            UIView.animate(withDuration: 0.25, animations: { 
                self.transform = CGAffineTransform.identity
            }, completion: { (isFinished) in
                
                completion()
                
            })
            
        
        })

        
        
        
    }
    
    

}
