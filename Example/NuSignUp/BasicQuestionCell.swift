//
//  BasicQuestionCell.swift
//  NuLikeSignUp
//
//  Created by Nucleus on 05/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp

class BasicQuestionCell: UITableViewCell,RegisterQuestion {
    
    

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        answerTextField.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func setAnswer(answer: Any) {
        if let text = answer as? String{
            answerTextField.text = text
        }
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
        self.endEditing(true)
    }

}
