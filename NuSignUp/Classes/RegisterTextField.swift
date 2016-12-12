//
//  RegisterTextField.swift
//  Pods
//
//  Created by Nucleus on 06/12/16.
//
//

import UIKit

public protocol OtherMaskDelegate{
    
    func maxNumberOfCharacters()->Int
    func applyMaskToText(text:String?)->String?
    
}


open class RegisterTextField: UITextField,UITextFieldDelegate {

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
    
    fileprivate var useMaskType:RegisterMaskType = RegisterMaskType.none{
        didSet{
            maxAllowedCharacters = MaxCharactersForMask(maskName: useMaskType).rawValue
        }
    }
    
    open var maxAllowedCharacters:Int = -1
    
    public var otherMaskDelegate:OtherMaskDelegate?
    
    open var textWithNoMask:String{
        get{
            if let text = self.text{
                switch useMaskType {
                case .cpf:
                    return RegisterMasks.removeCPFMaskTo(Text: text)
                case .cnpj:
                    return RegisterMasks.removeCNPJMaskTo(Text: text)
                case .rg:
                    return RegisterMasks.removeRGMaskTo(Text: text)

                default:
                    return text
                }
            }
            return ""
            
        }
    }
    
    /**
     Pass true if you want to change the text accordingly to the mask
     Pass false if you only want to check the number of allowed characters for the corresponding mask
     */
    @IBInspectable open var applyMask:Bool = true

    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    
    }
    
    //MARK: - TextFieldDelegate
    
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == ""{//removing characters
            return true
        }
        
        if let _ = self.text{
            let count = textWithNoMask.characters.count
            
            if useMaskType == RegisterMaskType.other{
                if let _ = otherMaskDelegate{
                    let max = otherMaskDelegate!.maxNumberOfCharacters()
                    if (max < 0 || max > count) && applyMask{
                        self.text = otherMaskDelegate!.applyMaskToText(text: self.text)
                        return true
                    }
                    return (max < 0 || max > count)
                }
                else{
                    assertionFailure("If you want to use other mask it is necessary to implement OtherMaskDelegate and inform it to param otherMaskDelegate")
                }
            }
            else if maxAllowedCharacters > 0 && maxAllowedCharacters > count && applyMask{
                switch useMaskType {
                case .cpf:
                    self.text = RegisterMasks.applyCPFMaskTo(Text: self.text!)
                case .cnpj:
                    self.text = RegisterMasks.applyCNPJMaskTo(Text: self.text!)
                case .rg:
                    self.text = RegisterMasks.applyRGMaskTo(Text: self.text!)

                default:
                    break
                }
                
                return true
            }
            return (maxAllowedCharacters < 0/*no mask*/) || /*some mask but only quant*/maxAllowedCharacters > 0 && maxAllowedCharacters > count
        }
        
        return true
    }
    
}
