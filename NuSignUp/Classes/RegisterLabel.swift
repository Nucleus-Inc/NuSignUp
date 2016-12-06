//
//  RegisterLabel.swift
//  Pods
//
//  Created by Nucleus on 06/12/16.
//
//

import UIKit

open class RegisterLabel: UILabel {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func emphasyzeText(text:String,color:UIColor,font:UIFont){
        var attibutedText = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName:self.font])
        if let range = self.text!.range(of: text) as? NSRange{
            
            attibutedText.addAttribute(NSFontAttributeName, value: font, range: range)
 
            attibutedText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)

        }
        
    }
}
