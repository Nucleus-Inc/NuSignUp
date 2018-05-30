//
//  JLProgressView.swift
//
//  Created by Nucleus on 07/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit


class JLProgressView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1
        }
    }
    
    
    @IBInspectable var maxStepValue:Int = 0{
        didSet{
            //updateToStep(currentStep, WithColor: nil)
        }
    }
    @IBInspectable var initialColor:UIColor = UIColor.clear{
        didSet{
            progressLayer?.backgroundColor = initialColor.cgColor
        }
    }
    
    @IBInspectable var verticalGrowth:Bool = false

    private var progressLayer:CALayer?
    private var currentStep:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addProgressLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //addProgressLayer()
    }
    
    
    private func addProgressLayer(){
        progressLayer = CALayer(layer: self.layer)
        progressLayer!.cornerRadius = self.layer.cornerRadius
        
        
        progressLayer!.backgroundColor = initialColor.cgColor
        progressLayer!.anchorPoint = CGPoint(x:0,y:0)
        
        progressLayer!.frame = CGRect(x: 0, y: 0, width: verticalGrowth ? self.frame.width : 0, height: verticalGrowth ? 0 : self.frame.height )
        progressLayer!.backgroundColor = initialColor.cgColor
        
        self.layer.addSublayer(progressLayer!)
        
    }
    
    private func valueForStep(_ step:Int)->CGFloat{
        if step > maxStepValue || maxStepValue == 0{
            return 0
        }
        
        if verticalGrowth{
            return self.frame.height*CGFloat(step)/CGFloat(maxStepValue)
        }
        else{
            return self.frame.width*CGFloat(step)/CGFloat(maxStepValue)
        }
        
    }//aein1234
    
    public func updateToStep(_ step:Int,WithColor color:UIColor?){
        guard let _ = progressLayer else{
            addProgressLayer()
            updateToStep(step, WithColor: color)
            return
        }
        
        if currentStep != step{
            currentStep = step
            let newValue = valueForStep(step)
            
            /*let parameter = verticalGrowth ? "height" : "width"
            let sizeAnimation = CABasicAnimation(keyPath: "bounds."+parameter)
            sizeAnimation.fromValue = verticalGrowth ? progressLayer!.bounds.height : progressLayer!.bounds.width
            sizeAnimation.toValue = newValue
            sizeAnimation.duration = 0.5
            self.progressLayer!.add(sizeAnimation, forKey: parameter+"animation")
            */
            
            if verticalGrowth{
                progressLayer!.bounds.size = CGSize(width: progressLayer!.bounds.width, height: newValue)
            }
            else{
                progressLayer!.bounds.size = CGSize(width: newValue, height: progressLayer!.bounds.height)
            }
            
            
            
            if let color = color{
                let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
                colorAnimation.fromValue = progressLayer!.backgroundColor
                colorAnimation.toValue = color.cgColor
                colorAnimation.duration = 0.5
                
                
                self.progressLayer!.add(colorAnimation, forKey: "colorAnimation")
                
                progressLayer!.backgroundColor = color.cgColor
            }
            
            self.layoutIfNeeded()
            
        }
    }

    
    
}
