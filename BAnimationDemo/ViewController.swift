//
//  ViewController.swift
//  BAnimationDemo
//
//  Created by 120v on 2018/11/14.
//  Copyright © 2018 MQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bgImgV: UIImageView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var hbBgView: UIView!
    @IBOutlet weak var hbImgV: UIImageView!
    @IBOutlet weak var moneyImgV: UIImageView!
    @IBOutlet weak var daiziImgV: UIImageView!
    @IBOutlet weak var closeImgV: UIImageView!
    @IBOutlet weak var closeImgVTop: NSLayoutConstraint!
    
    @IBOutlet weak var hbjbImgV: UIImageView!
    
    @IBOutlet weak var getMoneyView: UIView!
    
    @IBOutlet weak var moneyLB1: UILabel!
    @IBOutlet weak var moneyLB2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMoneyView.isHidden = true
        self.titleView.isHidden = true
        
        self.hbjbImgV.bringSubviewToFront(self.closeImgV)
        
        self.bgImgVScale()
        self.bgImgVRotation()
        self.hbBgViewGropAnimation()

        self.hbTapPosion()
        self.hbTapScale()
        
        self.open()
        
//        self.setTitleAnimation()
//
//        self.setGetMoneyViewAnimation()
        
//        self.lipFirstOpenAnimation()
        
//        UIView.animate(withDuration: 3, animations: {
//            self.gaiziImgV.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
//        }) { (finish) in
//
//        }
        
        self.popMoneyPaper()
    }
    
    //MARK: - 背景视图动画
    func bgImgVScale() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1
        scaleAnim.duration = 5
        scaleAnim.repeatCount = 1
        self.bgImgV.layer.add(scaleAnim, forKey: nil)
    }
    
    func bgImgVRotation() {
        let tranAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        tranAnim.duration = 10
        tranAnim.beginTime = CACurrentMediaTime()+2
        tranAnim.fillMode = CAMediaTimingFillMode.forwards
        tranAnim.isRemovedOnCompletion = false
        tranAnim.repeatCount = MAXFLOAT
        tranAnim.autoreverses = false
        tranAnim.delegate = self
        tranAnim.fromValue = 0
        tranAnim.toValue = Double.pi * 2
        self.bgImgV.layer.add(tranAnim, forKey: nil)
    }

    
    //MARK: - 红包视图
    func hbBgViewGropAnimation() {
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
    
    //MARK: - 红包袋子
    func hbTapPosion() {
        let posAnimation = CABasicAnimation(keyPath: "position.y")
        posAnimation.toValue = 250
        posAnimation.duration = 1
        posAnimation.isRemovedOnCompletion = false
        posAnimation.fillMode = CAMediaTimingFillMode.forwards
        posAnimation.beginTime = CACurrentMediaTime() + 2
        self.hbjbImgV.layer.add(posAnimation, forKey: nil)
    }
    
    func hbTapScale() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.toValue = 2.0
        scaleAnim.duration = 1
        scaleAnim.isRemovedOnCompletion = true
        scaleAnim.beginTime = CACurrentMediaTime() + 2
        self.hbjbImgV.layer.add(scaleAnim, forKey: nil)
    }
    
    //MARK: - 红包盖子
    func lipFirstOpenAnimation() {
        self.closeImgV.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.closeImgVTop.constant = -self.closeImgV.frame.size.height * 0.5
        var transForm3D = CATransform3DIdentity
//        transForm3D = CATransform3DIdentity
        transForm3D.m34 = -1.0/120
        transForm3D = CATransform3DRotate(transForm3D, CGFloat.pi, 1, 0, 0)
        let transAnimation = CABasicAnimation(keyPath: "transform")
        transAnimation.duration = 3
        transAnimation.isRemovedOnCompletion = false
        transAnimation.fillMode = CAMediaTimingFillMode.forwards
        transAnimation.isCumulative = true
        transAnimation.autoreverses = false
        transAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transAnimation.toValue = NSValue(caTransform3D: transForm3D)
        transAnimation.delegate = self
        transAnimation.beginTime = CACurrentMediaTime() + 2
//        transAnimation.setValue("lipFirstOpenAnimation", forKey: "lipFirstOpenAnimation")
        self.closeImgV.layer.add(transAnimation, forKey: nil)
    }
   
    
    func open() {
        self.closeImgV.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.closeImgVTop.constant = -self.closeImgV.frame.size.height * 0.5
        
        let rotate = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
        
        let transToCenter = CATransform3DMakeTranslation(0, 0, 0)
        let transBack = CATransform3DMakeTranslation(0, 0, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0/200
        let transformConcat = CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
        UIView.animate(withDuration: 3, delay: 2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
//            let rotate = CATransform3DMakeRotation(0, 1, 0, 0)
            self.closeImgV.layer.transform = CATransform3DConcat(rotate, transformConcat)
        }) { (finish) in
//            let rotate = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
//            self.gaiziImgV.layer.transform = CATransform3DConcat(rotate, transformConcat)
            self.hbBgView.insertSubview(self.closeImgV, aboveSubview: self.hbImgV)
            
            self.getMoneyView.isHidden = false
            self.titleView.isHidden = false
            
            self.setTitleAnimation()
            
            self.setGetMoneyViewAnimation()
        }
    }
    
    //MARK: - 红包
    func popMoneyPaper() {
        let positionAnim = CABasicAnimation(keyPath: "position")
        positionAnim.toValue = CGPoint(x: self.moneyImgV.center.x, y: self.moneyImgV.center.y-50)
        positionAnim.duration = 1
        positionAnim.isRemovedOnCompletion = false
        positionAnim.fillMode = CAMediaTimingFillMode.forwards
        positionAnim.beginTime = CACurrentMediaTime() + 5
        self.moneyImgV.layer.add(positionAnim, forKey: nil)
    }
    
    func setTitleAnimation() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1.0
        scaleAnim.duration = 1
        scaleAnim.isRemovedOnCompletion = true
//        scaleAnim.beginTime = CACurrentMediaTime() + 2
        self.titleView.layer.add(scaleAnim, forKey: nil)
    }
    
    func setGetMoneyViewAnimation() {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1
        scaleAnim.duration = 1
        scaleAnim.isRemovedOnCompletion = true
//        scaleAnim.beginTime = CACurrentMediaTime() + 2
        self.getMoneyView.layer.add(scaleAnim, forKey: nil)
    }
    
    func stopAnimation() {
        self.hbBgView.layer.removeAllAnimations()
    }
}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

    }
}

