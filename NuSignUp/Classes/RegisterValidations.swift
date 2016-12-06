//
//  RegisterValidations.swift
//  Pods
//
//  Created by Nucleus on 06/12/16.
//
//

import UIKit

public class RegisterValidations: NSObject {

    //http://www.geradorcpf.com/algoritmo_do_cpf.htm
    public class func isAValidCPFFormat(cpfString:String)->Bool{
        var cpfNumbers:[Int] = cpfString.characters.map { (charNumber) -> Int in
            let string = String(charNumber)
            let number = Int(string)
            return number!
        }
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
    
    
    public class func isAValidCNPJFormat(cnpjString:String)->Bool{
        var cnpjNumbers:[Int] = cnpjString.characters.map { (charNumber) -> Int in
            let string = String(charNumber)
            let number = Int(string)
            return number!
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
    
}
