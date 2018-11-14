//
//  SignUpPhoneNumberSVC.swift
//
//  Created by Nucleus on 08/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class SignUpPhoneNumberSVC: SignUpNameSVC {
    var maskRegex:String? = "([0-9]{3})([0-9]{3})([0-9]{4})" //USA
    var replacementRole:String? = "+1 ($1) $2-$3" //USA
    
    private var defaultMessage:String?

    private var isServerSideValid:Bool = false
    internal var sendingData:Bool = false
    
    var lastInvalidNumbers:[String] = []
    
    var unmaskedAnswer: String?{
        return self.stepAnswer?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+", with: "")
    }

    
    override func viewDidLoad() {
        defaultMessage = answerInfoTF.text
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - PhoneNumberSVC
    private func updateAnswerInfoMessage(){
        lastInvalidNumbers.contains(stepAnswer!) ? showAnswerInfoErrMessage() : showAnswerInfoDefaultMessage()
    }
    
    private func showAnswerInfoErrMessage(){
        self.answerInfoTF.text = "This phone number is in use."
        self.answerInfoTF.style = .error
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.style = .normal
    }
    
    private func showActivity(){
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.startAnimating()
        self.answerTF.rightView = view
        self.answerTF.rightViewMode = .always
    }
    
    private func hideActivity(){
        self.answerTF.rightView = nil
        self.answerTF.rightViewMode = .never
    }
    
    override func didChangeText(_ sender: Any) {
        if let maskRegex = maskRegex, let replacement = replacementRole{
            let text = answerTF.text ?? ""
            let newText = text.replacingOccurrences(of: maskRegex, with: replacement, options: [.regularExpression,.anchored], range: nil)
            self.answerTF.text = newText
        }
        super.didChangeText(sender)
    }
    
    
    //MARK: - Server methods
    
    private func validatePhoneNumberOnServer(){
        self.loadingMode(Loading: true)
        
        showActivity()

        let success = true
        let isAvailable = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideActivity()
            self.loadingMode(Loading: false)
            if success{
                if isAvailable{
                    
                    self.isServerSideValid = true
                    print("Add answer on answers")
                    self.delegate.addStepAnswer(answer: self.stepAnswer!, forKey: self.key)
                    self.goToNextStep()
                    
                }
                else{
                    self.answerTF.becomeFirstResponder()
                    self.isServerSideValid = false
                    self.lastInvalidNumbers.append(self.stepAnswer!)
                    self.showAnswerInfoErrMessage()
                    
                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: nil, Message: "This phone number is in use. Try another one.", OKAction: nil)
                }
            }
            else{
                self.answerTF.becomeFirstResponder()
                UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: nil, Message: "It was not possible to validate your phone number.", OKAction: nil)
            }

        }
    }
    
    
    //MARK: SignUpStepController methods
    
    override func didChangeStepAnswers() {
        super.didChangeStepAnswers()
        self.isServerSideValid = false
        self.updateAnswerInfoMessage()
    }
    
    override func didTapNextStepButton(button: UIButton) {
        
        if !isServerSideValid {

            if let stepAnswer = self.stepAnswer, !lastInvalidNumbers.contains(stepAnswer){
                //testa
                validatePhoneNumberOnServer()
            }
            else{
                self.showAnswerInfoErrMessage()
            }
        }
        else{
            print("Add answer on answers")
            delegate.addStepAnswer(answer: self.unmaskedAnswer!, forKey: self.key)
            goToNextStep()
        }
        
    }
    
    override func shouldPresentNextStepButton() -> Bool {
        if super.shouldPresentNextStepButton(){
            if let text = stepAnswer{
                return !lastInvalidNumbers.contains(text)
            }
        }
        return false
    }


}
