//
//  RJGiftChannelView.swift
//  04-礼物动画展示
//
//  Created by 小码哥 on 2016/12/17.
//  Copyright © 2016年 xmg. All rights reserved.
//

import UIKit


enum RJGiftChannelState {
    case idle  //普通闲置状态
    case animating  //正在动画
    case willEnd   //等待结束
    case endAnimating  //正在结束动画
    
}

class RJGiftChannelView: UIView {
    
    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: RJGiftDigitLabel!
    
    
    //栈内缓存的number
    fileprivate var cacheNumber : Int = 0
    
    //相同礼物连击 当前展示的数字
    fileprivate var currentNumber : Int = 0
    
    
    //当前view处于的状态
    var  state : RJGiftChannelState = .idle
    
    
    //动画结束后的闭包 
    var completionCallBack : ((RJGiftChannelView)-> Void)?
  
    var giftMode : RJGiftModel? {
        
        didSet {
            //1 .对模型进行检测
            guard let giftModel = giftMode else {
                return
            }
            
            // 2.给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURL)
            
            //3,将chanelView弹出  执行动画
            state = .animating
            performAnimation()
            
        }
        
        
    }
    

}


// MARK:- 设置UI界面
extension RJGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}


// MARK:- 对外提供的函数
extension RJGiftChannelView {

    
    func addOnceToCache()  {
        
        if state == .willEnd {
            //当前状态处于等待结束
            performDigitAnimation()
            //取消当前对象需要执行的方法
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        }else {
            cacheNumber += 1
        }
        
        
    }
    
    
    
    class func loadFromNib() -> RJGiftChannelView {
        return Bundle.main.loadNibNamed("RJGiftChannelView", owner: nil, options: nil)?.first as! RJGiftChannelView
    }
}


// MARK:- 执行动画代码
extension RJGiftChannelView {
    
    fileprivate func performAnimation()  {
        
        digitLabel.alpha = 1.0
        digitLabel.text = " x1 "
        UIView.animate(withDuration: 0.25, animations: { 
            self.alpha = 1.0
            self.frame.origin.x = 0
        }, completion: { isFinished in
           
            self.performDigitAnimation()
            
        })
    }
    
    //播放礼物动画
    fileprivate func performDigitAnimation()  {
      
        currentNumber += 1
        digitLabel.text = " x\(currentNumber) "
        //开始数字变化动画
        digitLabel.showDigitAnimation {
            //动画结束
            if self.cacheNumber > 0 {
                //有缓存数目
                self.cacheNumber -= 1
                self.performDigitAnimation()
            }else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
            }
            
        }
        
    
    }
    
    
    //执行消失动画
    @objc fileprivate func performEndAnimation() {
        state = .endAnimating
        UIView.animate(withDuration: 0.25, animations: { 
            
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
            
        }, completion: { isFinished in
        
            self.currentNumber = 0
            self.cacheNumber = 0
            self.giftMode = nil
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            self.digitLabel.alpha = 0.0
            
            if let cCallback = self.completionCallBack {
                cCallback(self)
            }
            
            
            
        })
        
    }

}
