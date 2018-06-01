//
//  SignUpMask.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import InputMask

public enum SignUpMask:Int{
    
    public init(name:String) {
        switch name.lowercased(){
        case "cpf":
            self = .cpf
        case "cnpj":
            self = .cnpj
        case "rg":
            self = .rg
        case "cep":
            self = .cep
        case "simplephone":
            self = .simplePhone
        case "brphone":
            self = .brPhone
        default:
            self = .none
        }
    }
    
    case none = 0
    case cpf = 1
    case cnpj = 2
    case rg = 3
    case cep = 5
    case simplePhone = 6
    case brPhone = 7
    
    public var maskString:String{
        switch self {
        case .cep:
            return "[00000]-[000]"
        case .cpf:
            return "[000].[000].[000]-[00]"
        case .cnpj:
            return "[00].}[000].[000]/[0000]-[00]"
        case .simplePhone:
            return "[900000000]"
        case .brPhone:
            return "+{55} [00] [900000000]"
        case .rg:
            return "[0].[000].[000]"
        default:
            return ""
        }
    }
    
    public func applyOnText(text:String)->String?{
        return SignUpMask.applyCustomMask(maskText: self.maskString, onText: text)
    }
    
    public func unmaskedText(_ text:String)->String?{
        switch self {
        case .cep:
            return text.replacingOccurrences(of: "-", with: "")
        case .cnpj:
            return text.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "/", with: "")
        case .brPhone, .simplePhone:
            return text.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: " ", with: "")
        case .cpf:
            return text.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "")
        case .rg:
            return text.replacingOccurrences(of: ".", with: "")
        default:
            return nil
        }
    }
    
    
    static public func applyCustomMask(maskText:String, onText text:String)->String?{
        do{
            let mask: Mask = try Mask(format: maskText)
            
            let result: Mask.Result = mask.apply(
                toText: CaretString(
                    string: text,
                    caretPosition: text.endIndex
                ),
                autocomplete: true // you may consider disabling autocompletion for your case
            )
            return result.formattedText.string
        }
        catch{
            
        }
        return nil
    }
}
