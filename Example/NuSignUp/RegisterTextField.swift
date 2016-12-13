//
//  RegisterTextField.swift
//  Pods
//
//  Created by Nucleus on 06/12/16.
//
//

import UIKit
import NuSignUp


class RegisterTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable open var useMask:String = "none"{
        didSet{
            useMaskType = RegisterMaskType(name: useMask)
        }
    }
    
    fileprivate var useMaskType:RegisterMaskType = RegisterMaskType.none
    

    open var textWithNoMask:String{
        get{
            if let text = self.text{
                return RegisterMasks.removeMaskType(type: useMaskType, OfText: text)
            }
            return ""
            
        }
    }
    
    public func canAddOtherCharacterOnText()->Bool{
        if let text = self.text{
            return RegisterMasks.canAddOtherCharacterOnText(text: text, withMask: useMaskType)
        }
        return true

    }
    
    public func applyMaskToText(){
        if let text = self.text, canAddOtherCharacterOnText(){
            self.text = RegisterMasks.applyMaskType(type: useMaskType, OnText: text)
        }
    }
}
