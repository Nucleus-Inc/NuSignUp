//
//  SignUpExtensions.swift
//  InputMask
//
//  Created by Nucleus on 30/05/2018.
//

import Foundation

extension Dictionary{
    public func keysArray()-> [Key]{
        return [Key](self.keys)
    }
}

extension NSObject{
    
    public func startListeningKeyboard(){
        registerKeyBoardNotifications()
    }
    
    public func stopListeningKeyboard(){
        removeWillShowKeyboardObserver()
        removeWillHideKeyboardObserver()
    }
    
    @objc open func keyboardWillAppear(keyboardInfo:[String:Any]){
        
    }
    
    @objc open func keyboardWillDisappear(keyboardInfo:[String:Any]){
        
    }
    
    fileprivate func registerKeyBoardNotifications(){
        addWillShowKeyboardObserver()
        addWillHideKeyboardObserver()
    }
    
    fileprivate func addWillShowKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(NSObject.showkeyBoardTarget(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    fileprivate func removeWillShowKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    fileprivate func addWillHideKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(NSObject.hideKeyBoardTarget(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func removeWillHideKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc final private func showkeyBoardTarget(_ notification:Notification){
        let info = (notification as NSNotification).userInfo as! [String:Any]
        
        keyboardWillAppear(keyboardInfo: info)
    }
    
    @objc final private func hideKeyBoardTarget(_ notification:Notification){
        let info = (notification as NSNotification).userInfo as! [String:AnyObject]
        
        keyboardWillDisappear(keyboardInfo: info)
    }
}
