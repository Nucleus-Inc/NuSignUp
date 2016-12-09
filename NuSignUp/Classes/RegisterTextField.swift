//
//  RegisterTextField.swift
//  Pods
//
//  Created by Nucleus on 06/12/16.
//
//

import UIKit



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
            
            
            if maxAllowedCharacters > 0 && maxAllowedCharacters > count && applyMask{
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
