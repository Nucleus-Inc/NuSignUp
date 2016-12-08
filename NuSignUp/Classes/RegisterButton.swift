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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        registerKeyBoardNotifications()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerKeyBoardNotifications()
    }
    
    func registerKeyBoardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterButton.showkeyBoardTarget(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterButton.hideKeyBoardTarget(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    func showkeyBoardTarget(_ notification:Notification){
        
        let info = (notification as NSNotification).userInfo as! [String:AnyObject]
        
        let keyBoardFrame = info[UIKeyboardFrameEndUserInfoKey]?.cgRectValue
        
        let size = self.frame.size
        let distToBotton  = self.superview!.frame.height - (self.frame.origin.y + size.height)
        let finalY = (self.superview!.frame.height - keyBoardFrame!.height) - self.frame.height - distToBotton
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: finalY), size: size)
            
        }, completion: {(finished) in
            //self.superview!.updateConstraints()
        })
    }
    
    func hideKeyBoardTarget(_ notification:Notification){
        
        //keyBoardFrame = CGRect.zero
        
    }


}
