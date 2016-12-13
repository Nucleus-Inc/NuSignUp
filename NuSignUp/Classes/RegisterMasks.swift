//
//  RegisterMasks.swift
//  Pods
//
//  Created by Nucleus on 09/12/16.
//
//

import UIKit

public enum RegisterMaskType:Int{
    
    public init(name:String) {
        switch name.lowercased(){
        case "cpf":
            self = .cpf
        case "cnpj":
            self = .cnpj
        case "rg":
            self = .rg
        case "other":
            self = .other
        default:
            self = .none
        }

    }
    
    public var maxAllowedCharacters:Int{
        get{
            return MaxCharactersForMask(maskName: self).rawValue
        }
    }
    
    case none = 0
    case cpf = 1
    case cnpj = 2
    case rg = 3
    case other = 4
}

enum MaxCharactersForMask:Int{
    public init(maskName:RegisterMaskType) {
        switch maskName{
        case .cpf:
            self = .cpf
        case .cnpj:
            self = .cnpj
        case .rg:
            self = .rg
        default:
            self = .none
        }
    }
    
    case none = -1
    case cpf = 11
    case cnpj = 14
    case rg = 9
}


open class RegisterMasks: NSObject {
    
    open class func canAddOtherCharacterOnText(text:String,withMask mask:RegisterMaskType)->Bool{
        let count = RegisterMasks.removeMaskType(type: mask, OfText: text).characters.count
        let maxAllowedCharacters = mask.maxAllowedCharacters
        return maxAllowedCharacters < 0 || maxAllowedCharacters > count
    }
    
    open class func applyMaskType(type:RegisterMaskType,OnText text:String)->String{
        let count = text.characters.count
        let maxAllowedCharacters = MaxCharactersForMask(maskName: type).rawValue
        var newText = text
        if RegisterMasks.canAddOtherCharacterOnText(text: text, withMask: type){
            switch type {
            case .cpf:
                newText = RegisterMasks.applyCPFMaskTo(Text: text)
            case .cnpj:
                newText = RegisterMasks.applyCNPJMaskTo(Text: text)
            case .rg:
                newText = RegisterMasks.applyRGMaskTo(Text: text)
            default:
                break
            }
            
        }
        return newText
    }
    
    open class func removeMaskType(type:RegisterMaskType,OfText text:String)->String{
        let count = text.characters.count
        switch type {
        case .cpf:
            return RegisterMasks.removeCPFMaskTo(Text: text)
        case .cnpj:
            return RegisterMasks.removeCNPJMaskTo(Text: text)
        case .rg:
            return RegisterMasks.removeRGMaskTo(Text: text)
        default:
            break
        }

        return text
    }

    //999.999.999-99
    public class func applyCPFMaskTo(Text text:String)->String{
        var maskedText = text
        let count = text.characters.count
        
        if count > 0{
            let lastChar = maskedText.characters.last!
            if lastChar == "." || lastChar == "-"{
                let index = text.index(text.startIndex, offsetBy: count - 1)
                maskedText = maskedText.substring(to: index)
            }
        }
        
        
        if count == 3 {
            let index = text.index(text.startIndex, offsetBy: 3)
            maskedText.insert(".", at: index)
        }
        
        if count == 7{
            let index = text.index(text.startIndex, offsetBy: 7)
            maskedText.insert(".", at: index)
        }
        
        if count == 11{
            let index = text.index(text.startIndex, offsetBy: 11)
            maskedText.insert("-", at: index)
        }
        return maskedText
    }
    
    public class func removeCPFMaskTo(Text text:String)->String{
        var maskedText = text
        maskedText = maskedText.replacingOccurrences(of: ".", with: "")
        maskedText = maskedText.replacingOccurrences(of: "-", with: "")
        return maskedText
    }
    
    //99.999.999/9999-99
    public class func applyCNPJMaskTo(Text text:String)->String{
        var maskedText = text
        let count = text.characters.count
        if count > 0{
            let lastChar = maskedText.characters.last!
            if lastChar == "." || lastChar == "-" || lastChar == "/"{
                let index = text.index(text.startIndex, offsetBy: count - 1)
                maskedText = maskedText.substring(to: index)
            }
        }
        
        
        
        if count == 2 {
            let index = text.index(text.startIndex, offsetBy: 2)
            maskedText.insert(".", at: index)
        }
        
        if count == 6{
            let index = text.index(text.startIndex, offsetBy: 6)
            maskedText.insert(".", at: index)
        }
        
        if count == 10{
            let index = text.index(text.startIndex, offsetBy: 10)
            maskedText.insert("/", at: index)
        }
        
        if count == 15{
            let index = text.index(text.startIndex, offsetBy: 15)
            maskedText.insert("-", at: index)
        }

        return maskedText
    }
    
    public class func removeCNPJMaskTo(Text text:String)->String{
        var maskedText = text
        maskedText = maskedText.replacingOccurrences(of: ".", with: "")
        maskedText = maskedText.replacingOccurrences(of: "/", with: "")
        maskedText = maskedText.replacingOccurrences(of: "-", with: "")
        return maskedText
    }

    
    
    public class func applyRGMaskTo(Text text:String)->String{
        var maskedText = text
        let count = text.characters.count
        
        if count > 0{
            let lastChar = maskedText.characters.last!
            if lastChar == "." || lastChar == "-"{
                let index = text.index(text.startIndex, offsetBy: count - 1)
                maskedText = maskedText.substring(to: index)
            }
        }
        
        
        
        if count == 2{
            let index = text.index(text.startIndex, offsetBy: 2)
            maskedText.insert(".", at: index)
        }
        
        if count == 6 {
            let index = text.index(text.startIndex, offsetBy: 6)
            maskedText.insert(".", at: index)
        }
        
        if count == 10{
            let index = text.index(text.startIndex, offsetBy: 10)
            maskedText.insert("-", at: index)
        }
        return maskedText
    }
    
    public class func removeRGMaskTo(Text text:String)->String{
        var maskedText = text
        maskedText = maskedText.replacingOccurrences(of: ".", with: "")
        maskedText = maskedText.replacingOccurrences(of: "-", with: "")
        return maskedText
    }
}
