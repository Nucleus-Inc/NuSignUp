//
//  RegisterButton.swift
//  Pods
//
//  Created by José Lucas Souza das Chagas on 07/12/16.
//
//

import UIKit

open class RegisterButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate var distToOrigin:CGFloat = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        registerKeyBoardNotifications()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerKeyBoardNotifications()
    }
    
    
    
    
    
    
    
    
    func registerKeyBoardNotifications(){
        addWillShowKeyboardObserver()
        addWillHideKeyboardObserver()
    }
    
    func addWillShowKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterButton.showkeyBoardTarget(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func removeWillShowKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func addWillHideKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterButton.hideKeyBoardTarget(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeWillHideKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    
    func showkeyBoardTarget(_ notification:Notification){
        let info = (notification as NSNotification).userInfo as! [String:AnyObject]
        
        let keyBoardFrame = info[UIKeyboardFrameEndUserInfoKey]?.cgRectValue
        let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]
        
        let size = self.frame.size
        
        if keyBoardFrame!.origin.y < self.frame.origin.y + size.height {
            
            distToOrigin = (self.frame.origin.y + size.height) - (keyBoardFrame!.origin.y + 5)
            
            let finalY = self.frame.origin.y - distToOrigin
                        
            UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
                self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: finalY), size: size)
                
            }, completion: {(finished) in
                self.superview!.updateConstraints()
            })
        }

    }
    
    
    func hideKeyBoardTarget(_ notification:Notification){
        let info = (notification as NSNotification).userInfo as! [String:AnyObject]
        
        let keyBoardFrame = info[UIKeyboardFrameEndUserInfoKey]?.cgRectValue
        let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]
        
        let size = self.frame.size

        let finalY = self.frame.origin.y + distToOrigin
        distToOrigin = 0
        
        UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: finalY), size: size)
            
        }, completion: {(finished) in
            self.superview!.updateConstraints()
        })
    }


}
