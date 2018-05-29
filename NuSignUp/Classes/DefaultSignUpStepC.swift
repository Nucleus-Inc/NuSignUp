//
//  DefaultSignUpStepC.swift
//  Upme-Professional
//
//  Created by Nucleus on 29/05/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class DefaultSUpSDelegate:SignUpStepDelegate{
    
    //MARK: - SignUpStepProtocol Things
    var finishReviewBlock: PopReviewBlock?
    var reviewMode:SignUpReviewMode = .none
    var answers: [String : Any]?
    var isOptional: Bool = false
    
    //MARK: NextStepButton methods
    
    /**
     This implementation only decide based on 'isOptional' variable if should present or not the button.
     */
    func setUpNextStepButton(button: UIButton) {
        button.drawBorderWith(Color: button.titleColor(for: .normal)!, AndWidth: 1)
        isOptional ? presentNextStepButton(button: button) : hideNextStepButton(button: button)
    }
    
    func updateAppearanceOf(NextStepButton button: UIButton) {
        //TODO: This method does nothing, you can add your own implementation if you pretend to change button appearance on changes on 'reviewMode' for example
    }
    
    func presentNextStepButton(button: UIButton) {
        button.isHidden = false
    }
    
    func hideNextStepButton(button: UIButton) {
        button.isHidden = true
    }
    
}
