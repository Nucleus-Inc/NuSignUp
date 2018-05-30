//
//  SignUpConfig.swift
//  InputMask
//
//  Created by Nucleus on 30/05/2018.
//

import Foundation

typealias NewDelegateIntance = ()->DefaultSUpSDelegate

/**
 This singleton is for configurations of SignUpStack
 */
public class SignUpStack{
    
    private static var instance:SignUpStack?
    
    public static var config:SignUpStack{
        guard let i = instance else{
            instance = SignUpStack()
            return instance!
        }
        return i
    }
    
    private init(){}
    
    var newDelegateInstance:NewDelegateIntance = {
        return DefaultSUpSDelegate()
    }
    
    /**
     Call this method if you want that 'SignUpStepVC' use as delegate a class that inherit from 'DefaultSUpSDelegate'.
     */
    public func baseStepDelegateType<T:DefaultSUpSDelegate>(_ type:T.Type){
        newDelegateInstance = {
            return T()
        }
    }
    
    
}
