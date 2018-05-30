//
//  ExampleSignUpDelegate.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import NuSignUp

class ExampleSignUpDelegate:DefaultSUpSDelegate{
    
    override public func updateAppearanceOf(NextStepButton button: UIButton) {
        if reviewMode != .none{
            button.setTitle("Confirm", for: .normal)
        }
        else{
            button.setTitle("Next", for: .normal)
        }
    }
    
}
