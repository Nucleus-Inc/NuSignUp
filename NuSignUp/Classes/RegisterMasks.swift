//
//  RegisterMasks.swift
//  Pods
//
//  Created by Nucleus on 09/12/16.
//
//

import UIKit

public enum RegisterMaskType:Int{
    
    init(name:String) {
        switch name.lowercased(){
        case "cpf":
            self = .cpf
        case "cnpj":
            self = .cnpj
        case "rg":
            self = .rg
        default:
            self = .none
        }

    }
    case none = 0
    case cpf = 1
    case cnpj = 2
    case rg = 3
}

public enum MaxCharactersForMask:Int{
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


public class RegisterMasks: NSObject {
    
    
    static public func applyCPFMaskTo(Text text:String)->String{
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
    
    static public func removeCPFMaskTo(Text text:String)->String{
        var maskedText = text
        maskedText = maskedText.replacingOccurrences(of: ".", with: "")
        maskedText = maskedText.replacingOccurrences(of: "-", with: "")
        return maskedText
    }
    
    
    static public func applyCNPJMaskTo(Text text:String)->String{
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
    
    static public func removeCNPJMaskTo(Text text:String)->String{
        var maskedText = text
        maskedText = maskedText.replacingOccurrences(of: ".", with: "")
        maskedText = maskedText.replacingOccurrences(of: "/", with: "")
        maskedText = maskedText.replacingOccurrences(of: "-", with: "")
        return maskedText
    }

    
    
    static public func applyRGMaskTo(Text text:String)->String{
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
    
    static public func removeRGMaskTo(Text text:String)->String{
        var maskedText = text
        maskedText = maskedText.replacingOccurrences(of: ".", with: "")
        maskedText = maskedText.replacingOccurrences(of: "-", with: "")
        return maskedText
    }

    
    
    
}
