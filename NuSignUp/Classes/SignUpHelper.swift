//
//  SignUpHelper.swift
//
//  Created by Nucleus on 03/05/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit

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



