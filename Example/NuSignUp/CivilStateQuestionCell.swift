//
//  CivilStateQuestionCellTableViewCell.swift
//  NuSignUp
//
//  Created by Nucleus on 07/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp

class CivilStateQuestionCell: UITableViewCell,RegisterQuestion {
    /**
     Do not assign a value to this property just use the methods of this protocol to send constant updates to user about the state of your answer, more details take a look on example project
     */
    public var answerListener: AnswerListener!{
        didSet{
            self.answerListener.changeAnswer(answer: self.answerValue, ToStateValid: self.isAValidAnswer())
        }
    }


    


    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var civilStateButtons: [UIButton]!
    
    
    var answerValue:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func stateButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            answerValue = nil
            sender.isSelected = false
        }
        else{
            for button in civilStateButtons{
                let title = button.title(for: UIControlState.normal)!
                let currentButtonTitle = sender.title(for: UIControlState.normal)!
                answerValue = currentButtonTitle
                sender.isSelected = true
                if button.isSelected && title.caseInsensitiveCompare(currentButtonTitle) != ComparisonResult.orderedSame{
                    button.isSelected = false
                }
            }
        }
        
        self.answerListener.changeAnswer(answer: self.answerValue, ToStateValid: self.isAValidAnswer())

    }
    
    
    
    

    
    public func setAnswer(answer: Any) {
        if let answer = answer as? String{
            self.answerValue = answer
            for button in civilStateButtons{
                let title = button.title(for: UIControlState.normal)!
                button.isSelected = title.caseInsensitiveCompare(answer) == ComparisonResult.orderedSame
            }
            self.answerListener.changeAnswer(answer: self.answerValue, ToStateValid: self.isAValidAnswer())
        }
        
    }
    public func answer() -> Any? {
        return answerValue
    }
    
    func isAValidAnswer() -> Bool {
        
        if let _ = answerValue{
            return true
        }
        return false

    }
    
    func activeQuestion() {
        
    }

    public func desactiveQuestion() {
        
    }

}
