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
    }
    
    
    
    

    
    public func setAnswer(answer: Any) {
        if let answer = answer as? String{
            for button in civilStateButtons{
                let title = button.title(for: UIControlState.normal)!
                
                if title.caseInsensitiveCompare(answer) != ComparisonResult.orderedSame{
                    button.isSelected = true
                }
            }
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
