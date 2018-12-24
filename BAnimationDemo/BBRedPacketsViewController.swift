//
//  BBRedPacketsViewController.swift
//  BAnimationDemo
//
//  Created by 120v on 2018/12/24.
//  Copyright © 2018 MQ. All rights reserved.
//

import UIKit

class BBRedPacketsViewController: UIViewController {
    
    @IBOutlet weak var bgImgV: UIImageView!
    
    @IBOutlet weak var hbBgView: UIView!        //红包袋子后
    @IBOutlet weak var hbImgV: UIImageView!     //红包
    
    @IBOutlet weak var hbGaiziShangImgV: UIImageView! //红包盖子上
    @IBOutlet weak var oldMoneyLB: UILabel!              //旧金额
    @IBOutlet weak var newMoneyLB: UILabel!              //新金额
    @IBOutlet weak var hbGaiziXiaImgV: UIImageView!//红包盖子下
    @IBOutlet weak var hbGaiziImgVTop: NSLayoutConstraint!
    
    @IBOutlet weak var hbTipeImgV: UIImageView! //红包绳子
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgImgV.isHidden = true
        self.hbGaiziShangImgV.isHidden = true
        self.oldMoneyLB.isHidden = true
        self.newMoneyLB.isHidden = true
        
        self.addHbBgViewGropAnimation()
        self.addHbTapPosionAnimation()
        self.addHbTapScalAnimation()
        self.addHbGaiziAnimation()
        self.addNewMoneyLBAnimation()
    }
    
    //MARK: - 缩放动画
    func addBigViewScaleAnimation() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1
        scaleAnim.duration = 0.8
        scaleAnim.repeatCount = 1
        self.bgImgV.layer.add(scaleAnim, forKey: nil)
    }
    
    //MARK: - 旋转动画
    func addBigViewRotationAnimation() {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.duration = 10
        rotationAnim.beginTime = CACurrentMediaTime()+1
        rotationAnim.fillMode = CAMediaTimingFillMode.forwards
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.autoreverses = false
        rotationAnim.delegate = self
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        self.bgImgV.layer.add(rotationAnim, forKey: nil)
    }

    
    //MARK: - 红包视图
    func addHbBgViewGropAnimation() {
        //旋转动画
        let rotaAnim = CABasicAnimation(keyPath: "transform.rotation.y")
        rotaAnim.duration = 2
        rotaAnim.fillMode = CAMediaTimingFillMode.forwards
        rotaAnim.isRemovedOnCompletion = false
        rotaAnim.repeatCount = MAXFLOAT
        rotaAnim.autoreverses = false
        rotaAnim.delegate = self
        rotaAnim.fromValue = 0
        rotaAnim.toValue = Double.pi * 2
        
        //缩放动画
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1
        scaleAnim.fillMode = CAMediaTimingFillMode.forwards
        scaleAnim.isRemovedOnCompletion = false
        
        //动画组
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [rotaAnim,scaleAnim]
        groupAnim.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        groupAnim.duration = 2
        groupAnim.repeatCount = 1
        groupAnim.delegate = self
        groupAnim.autoreverses = false
        self.hbBgView.layer.add(groupAnim, forKey: "groupAnimation")
    }
    
    //MARK: - 红包带子
    func addHbTapPosionAnimation() {
        let posAnimation = CABasicAnimation(keyPath: "position.y")
        posAnimation.toValue = 280
        posAnimation.duration = 1
        posAnimation.isRemovedOnCompletion = false
        posAnimation.fillMode = CAMediaTimingFillMode.forwards
        posAnimation.beginTime = CACurrentMediaTime() + 2
        self.hbTipeImgV.layer.add(posAnimation, forKey: nil)
    }
    
    //MARK: - 红包带子
    func addHbTapScalAnimation() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.toValue = 2.0
        scaleAnim.duration = 0.8
        scaleAnim.autoreverses = false
        scaleAnim.isRemovedOnCompletion = true
        scaleAnim.beginTime = CACurrentMediaTime() + 2
        self.hbTipeImgV.layer.add(scaleAnim, forKey: nil)
    }
    
    //MARK: - 红包盖子
    func addHbGaiziAnimation() {
        self.hbGaiziXiaImgV.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.hbGaiziImgVTop.constant = -self.hbGaiziXiaImgV.frame.size.height * 0.5
        
        let rotate = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
        
        let transToCenter = CATransform3DMakeTranslation(0, 0, 0)
        let transBack = CATransform3DMakeTranslation(0, 0, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0/200
        let transformConcat = CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
        UIView.animate(withDuration: 1.5, delay: 3.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.hbGaiziXiaImgV.layer.transform = CATransform3DConcat(rotate, transformConcat)
        }) { (finish) in
            self.bgImgV.isHidden = false
            self.hbGaiziXiaImgV.isHidden = true
            self.hbGaiziShangImgV.isHidden = false
            self.oldMoneyLB.isHidden = false
            self.newMoneyLB.isHidden = false
            
            self.addHbPopAnimation()
            self.addBigViewScaleAnimation()
            self.addBigViewRotationAnimation()
        }
    }
    
    //MARK: - 红包弹出
    func addHbPopAnimation() {
        let positionAnim = CABasicAnimation(keyPath: "position")
        positionAnim.toValue = CGPoint(x: self.hbImgV.center.x, y: self.hbImgV.center.y-50)
        positionAnim.duration = 0.6
        positionAnim.isRemovedOnCompletion = false
        positionAnim.fillMode = CAMediaTimingFillMode.forwards
        positionAnim.beginTime = CACurrentMediaTime() + 0
        self.hbImgV.layer.add(positionAnim, forKey: nil)
    }
    
    //MARK: - 钱
    func addNewMoneyLBAnimation() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 20
        scaleAnim.toValue = 1
        scaleAnim.duration = 1
        scaleAnim.isRemovedOnCompletion = true
        scaleAnim.beginTime = CACurrentMediaTime() + 1
        self.newMoneyLB.layer.add(scaleAnim, forKey: nil)
    }
}


extension BBRedPacketsViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}
