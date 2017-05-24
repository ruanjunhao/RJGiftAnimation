//
//  RJGiftContainerView.swift
//  RJGiftAnimation
//
//  Created by ruanjh on 2017/5/24.
//  Copyright © 2017年 app. All rights reserved.
//

import UIKit

private let kChannelCount = 3
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10


class RJGiftContainerView: UIView {

    //当前栈道数组
    fileprivate lazy var channelViews : [RJGiftChannelView] = [RJGiftChannelView]()
    
    fileprivate lazy var cacheGiftModels : [RJGiftModel] = [RJGiftModel]()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}


extension RJGiftContainerView {
    
    fileprivate func setupUI()  {
        //根据当前渠道数 创建RJGiftChannelView
        let w : CGFloat = bounds.width
        let h : CGFloat  = kChannelViewH
        let x : CGFloat = 0.0
        
        for i in 0..<kChannelCount {
            
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            let channelView = RJGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            
            channelViews.append(channelView)
            
            channelView.completionCallBack = { (channelView) in
                
                //动画结束后 检查有没有缓存记录
                guard self.cacheGiftModels.count != 0 else {
                    return
                }
                
                //2.取出缓存的第一个模型
                let firstGiftModel = self.cacheGiftModels.first!
                
                self.cacheGiftModels.removeFirst()
                
                //让闲置的频道执行动画
                channelView.giftMode = firstGiftModel
                
                
                //将数组中其他的 有和firstGiftModel相同的模型放入到ChanelView缓存中
                
                for i in (0..<self.cacheGiftModels.count).reversed() {
                    
                    let gifmodel = self.cacheGiftModels[i]
                    if gifmodel.isEqual(firstGiftModel) {
                        channelView.addOnceToCache()
                        self.cacheGiftModels.remove(at: i)
                    }
                }
                
                
            }

            
        }
        
    }
}



extension RJGiftContainerView {

    func showGiftModel(_ gifMode : RJGiftModel)  {
        
        // 1.判断当前正在显示的channelView 和新赠送的礼物（username/giftname）
        if let channelView = checkUsingChanelView(gifMode) {
            
            channelView.addOnceToCache()
            return
        }
        
         // 2.判断有没有闲置的ChanelView
        if let channelView = checkIdleChannelView() {
            channelView.giftMode = gifMode
        }
        
        //3.将数据放入缓存中
        
        cacheGiftModels.append(gifMode)
        
    }
    
    

    
    fileprivate func  checkUsingChanelView (_ giftModel : RJGiftModel) -> RJGiftChannelView? {
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftMode) && channelView.state != .endAnimating {
                return channelView
            }
        }
        
         return nil
     }
    
    
    fileprivate func checkIdleChannelView() -> RJGiftChannelView? {
        
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
    
    
}










