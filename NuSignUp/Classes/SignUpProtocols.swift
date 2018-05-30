//
//  SignUpProtocols.swift
//
//  Created by Nucleus on 29/05/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

public protocol SignUpStackC{
    var numbOfSteps:Int{get}
    func updateForStep(step:Int)
}


public enum SignUpStepSegues:String{
    case nextStep = "nextStep"
    case reviewStepNextStep = "reviewStepNS"
    case reviewSectionNextStep = "reviewSectionNS"
}

public enum SignUpReviewMode:Int{
    case none = 0
    case section = 1
    case step_pop = 2
    case step_push = 3
}

public typealias PopReviewBlock = (_ updatedAnswers:[String:Any]?)->Void
public protocol SignUpStepDelegate:class{
    var isOptional:Bool{get set}
    
    /**
     All the answers added til this step
     */
    var answers:[String:Any]?{get set}
    
    /**
     The value of this parameter indicate if you are on some review mode
     Depending of the value of 'SignUpReviewMode' when you call the method goToNextStep diferent segues will be performed
     */
    var reviewMode:SignUpReviewMode{get set}
    
    /**
     This is a closure that mus be executed when review mode started with a perform segue finishes this to send back the updated data to review SignUpVC
     */
    var finishReviewBlock:PopReviewBlock?{get set}
    
    /**
     Set all basic configurations on button, for example if it must be hidden or not, set its default title etc.
     */
    func setUpNextStepButton(button:UIButton)
    /**
     Add all necessary code to update button appearance, like its title based on some change, for example based on changes on 'reviewMode'
     */
    func updateAppearanceOf(NextStepButton button:UIButton)
    /**
     Call this method to execute all animations to present next step button
     You can override this method to execute custom animations
     This method is called on default implementation of 'didChangeStepAnswers' when user changes its answer to some one that is valid
     */
    func presentNextStepButton(button:UIButton)
    /**
     Call this method to execute all animations to hide next step button
     You can override this method to execute custom animations
     This method is called on default implementation of 'didChangeStepAnswers' when user changes its answer to some one that is not valid
     */
    func hideNextStepButton(button:UIButton)
    
}

extension SignUpStepDelegate{
    public func addStepAnswer(answer:Any,forKey key:String){
        let subKeys:[String] = key.components(separatedBy: "->")
        guard let _ = answers else{
            answers = [String:Any]()
            add(keyPath: subKeys, pos: 0, dict: &answers!, answer: answer)
            return
        }
        add(keyPath: subKeys, pos: 0, dict: &answers!, answer: answer)
    }
    
    
    private func add(keyPath:[String],pos:Int, dict: inout [String:Any],answer:Any){
        let key = keyPath[pos]
        if pos < keyPath.count - 1{
            if let _ = dict[key] as? [String:Any]{
                var temp = dict[key] as! [String:Any]
                add(keyPath: keyPath, pos: pos + 1, dict: &temp, answer: answer)
                dict[key] = temp
            }
            else{
                var temp = [String:Any]()
                add(keyPath: keyPath, pos: pos + 1, dict: &temp, answer: answer)
                dict[key] = temp
            }
        }
        else{
            dict[key] = answer
        }
    }
    
    public func answer(ForKey key:String)->Any?{
        let subKeys:[String] = key.components(separatedBy: "->")
        let k = subKeys.last!
        var values = answers
        
        if let _ = values{
            for pos in 0..<subKeys.count - 1{
                let currentKey = subKeys[pos]
                if let v = values![currentKey] as? [String:Any]{
                    values = v
                }
                else{
                    return nil
                }
            }
            
            if let values = values, let answer = values[k] as? String{
                return answer
            }
        }
        
        return nil
    }
}


public protocol SignUpStepController{
    var delegate:SignUpStepDelegate{get set}
    /**
     This method must be called everytime user make some change on his step answer
     */
    func didChangeStepAnswers()
    /**
     This method calls the correct segue to transition to next step
     You can override this method if you want to perform some custom segue
     */
    func goToNextStep()
    
    /**
     The Default implementation of this method does nothing
     
     
     You must override this method, it should contain all necessary code that add your step answer on answers
     - parameter button: The button that was tapped and will make it change to next step or subStep
     */
    func didTapNextStepButton(button: UIButton)
    
    /**
     This method must execute the necessary code to present or not the step button based on current user answer.
     */
    func shouldPresentNextStepButton() -> Bool
    
}
