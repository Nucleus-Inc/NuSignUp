//
//  SignUpHelper.swift
//  Upme-Professional
//
//  Created by Nucleus on 03/05/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
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

    var maskString:String{
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
    
    func applyOnText(text:String)->String?{
        return SignUpMask.applyCustomMask(maskText: self.maskString, onText: text)
    }
    
    func unmaskedText(_ text:String)->String?{
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
    
    
    static func applyCustomMask(maskText:String, onText text:String)->String?{
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

open class SignUpValidations{
    /**
     Without mask
     */
    public class func isAValidCPFFormat(cpfString:String)->Bool{
        /*var cpfNumbers:[Int?] = cpfString.characters.map { (charNumber) -> Int? in
            let string = String(charNumber)
            if let number = Int(string){
                return number
            }
            
            return nil
        }*/
        //to avoid problems with cpfs with only 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        for n in 0..<10{
            let str = "\(n)"
            var equal = true
            for char in cpfString.sorted(){
                if str != String(char){
                    equal = false
                    break
                }
            }
            
            if equal{
                return false
            }
        }

        var cpfNumbers:[Int] = cpfString.reduce(into: [Int]()) { (array, char) in
            let string = String(char)
            if let number = Int(string){
                array.append(number)
            }
        }

        if cpfNumbers.count > 10{
            let firstDigit = cpfNumbers[9]
            let secondDigit = cpfNumbers[10]
            var valueOne:Int = 0//for first digit
            var valueTwo:Int = 0//for second digit
            for i in 0..<9{//first nine numbers
                valueOne += (10 - i) * cpfNumbers[i]
                valueTwo += (11 - i) * cpfNumbers[i]

            }
            
            let rest = valueOne % 11
            
            let correctFirstDigit = rest < 2 ? 0 : 11 - rest
            
            if correctFirstDigit != firstDigit{
                return false
            }
            
            valueTwo += 2*firstDigit
            let restTwo = valueTwo % 11
            
            
            let correctSecondDigit = restTwo < 2 ? 0 : 11 - restTwo
            
            if correctSecondDigit != secondDigit{
                return false
            }
            return true
        }
        
        return false
    }
    
    
    public class func isAValidCNPJFormat(cnpjString:String)->Bool{
        /*var cnpjNumbers:[Int] = cnpjString.characters.map { (charNumber) -> Int in
            let string = String(charNumber)
            let number = Int(string)
            return number!
        }*/
        
        var cnpjNumbers:[Int] = cnpjString.reduce(into: [Int]()) { (array, char) in
            let string = String(char)
            if let number = Int(string){
                array.append(number)
            }
        }

        
        let firstDigit = cnpjNumbers[12]
        let secondDigit = cnpjNumbers[13]
        
        
        let firstDigitWeights = [5,4,3,2,9,8,7,6,5,4,3,2]
        let secondDigitWeights = [6,5,4,3,2,9,8,7,6,5,4,3,2]
        
        
        var valueOne:Int = 0//for first digit
        var valueTwo:Int = 0//for first digit
        for i in 0..<firstDigitWeights.count{//first twelve numbers
            valueOne += firstDigitWeights[i] * cnpjNumbers[i]
            valueTwo += secondDigitWeights[i] * cnpjNumbers[i]
            
        }
        
        let rest = valueOne % 11
        
        let correctFirstDigit = rest < 2 ? 0 : 11 - rest
        if correctFirstDigit != firstDigit{
            return false
        }
        
        
        
        valueTwo += 2*firstDigit
        let restTwo = valueTwo % 11
        
        
        let correctSecondDigit = restTwo < 2 ? 0 : 11 - restTwo
        
        if correctSecondDigit != secondDigit{
            return false
        }
        return true
    }
    public class func isAValidEmailFormat(emailString:String)->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
}



