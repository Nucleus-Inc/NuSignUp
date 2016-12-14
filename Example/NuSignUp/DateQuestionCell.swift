//
//  DateQuestionCell.swift
//  NuSignUp
//
//  Created by José Lucas Souza das Chagas on 06/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp

class DateQuestionCell: UITableViewCell,RegisterQuestion {
    public var answerListener: AnswerListener!{
        didSet{
            self.answerListener.changeAnswer(answer: self.bornDatePicker.date, ToStateValid: self.isAValidAnswer())
        }
    }



    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var bornDatePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }

       
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setAnswer(answer: Any) {
        if let bornDate = answer as? Date{
            bornDatePicker.date = bornDate
        }
        
        self.answerListener.changeAnswer(answer: self.bornDatePicker.date, ToStateValid: self.isAValidAnswer())
    }
    public func answer() -> Any? {
        return bornDatePicker.date
    }
    
    func isAValidAnswer() -> Bool {
       
        if Date().timeIntervalSince1970 - bornDatePicker.date.timeIntervalSince1970 > 3600*24{
            return true
        }
        return false
    }
    
    func activeQuestion() {
        //self.superview!.endEditing(true)
        bornDatePicker.becomeFirstResponder()
    }
    
    public func desactiveQuestion() {
        bornDatePicker.resignFirstResponder()

    }
}
