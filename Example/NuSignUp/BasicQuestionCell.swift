//
//  BasicQuestionCell.swift
//  NuLikeSignUp
//
//  Created by Nucleus on 05/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp

class BasicQuestionCell: UITableViewCell,RegisterQuestion,UITextFieldDelegate {
    
    public var answerListener: AnswerListener!{
        didSet{
            self.answerListener.changeAnswer(answer: self.answerTextField.text, ToStateValid: self.isAValidAnswer())
        }
    }

    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerTextField: RegisterTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerTextField.delegate = self
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func setAnswer(answer: Any) {
        if let text = answer as? String{
            answerTextField.text = text
        }
        else{
            answerTextField.text = nil
        }
        
        self.answerListener.changeAnswer(answer: self.answerTextField.text, ToStateValid: self.isAValidAnswer())
    }

    
    
    public func answer() -> Any? {
        return answerTextField.text
    }
    
    func isAValidAnswer() -> Bool {
        if let text = answerTextField.text, text.characters.count > 10{
            return true
        }
        return false
    }
    
    func activeQuestion() {
        answerTextField.becomeFirstResponder()
    }
    
    func desactiveQuestion(){
        self.superview!.endEditing(true)
    }
    
    
    //MARK: - TextField delegate
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if string == ""{//removing characters
            return true
        }
        self.answerTextField.applyMaskToText()
        
        self.answerListener.changeAnswer(answer: self.answerTextField.text, ToStateValid: self.isAValidAnswer())

        
        return self.answerTextField.canAddOtherCharacterOnText()
    }

}
