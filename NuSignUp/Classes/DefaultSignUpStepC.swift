//
//  DefaultSignUpStepC.swift
//
//  Created by Nucleus on 29/05/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

open class DefaultSUpSDelegate:SignUpStepDelegate{
    
    //MARK: - SignUpStepProtocol Things
    open var finishReviewBlock: PopReviewBlock?
    open var reviewMode:SignUpReviewMode = .none
    open var answers: [String : Any]?
    open var isOptional: Bool = false
    
    public required init(){}
    
    //MARK: NextStepButton methods
    
    /**
     This implementation only decide based on 'isOptional' variable if should present or not the button.
     */
    open func setUpNextStepButton(button: UIButton) {
        isOptional ? presentNextStepButton(button: button) : hideNextStepButton(button: button)
    }
    
    open func updateAppearanceOf(NextStepButton button: UIButton) {
        //TODO: This method does nothing, you can add your own implementation if you pretend to change button appearance on changes on 'reviewMode' for example
    }
    
    open func presentNextStepButton(button: UIButton) {
        button.isEnabled = true
    }
    
    open func hideNextStepButton(button: UIButton) {
        button.isEnabled = false
    }
    
}
