//
//  SignUpPhoneNumberSVC.swift
//
//  Created by Nucleus on 08/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class SignUpPhoneNumberSVC: SignUpNameSVC {
    
    private var defaultMessage:String?
    private var defaultColor:UIColor?

    private var isServerSideValid:Bool = false
    internal var sendingData:Bool = false
    
    var lastInvalidNumbers:[String] = []

    override func viewDidLoad() {
        defaultMessage = answerInfoTF.text
        defaultColor = answerInfoTF.textColor
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
        self.answerInfoTF.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.textColor = defaultColor
    }
    
    /*
    override func addStepAnswer() {
        guard let _ = answers else{
            self.answers = [String:Any]()
            self.answers![key] = stepAnswer!
            return
        }
        
        self.answers![key] = stepAnswer!
    }
     */
        
    private func showActivity(){
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.startAnimating()
        self.answerTF.rightView = view
        self.answerTF.rightViewMode = .always
    }
    
    private func hideActivity(){
        self.answerTF.rightView = nil
        self.answerTF.rightViewMode = .never
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
            delegate.addStepAnswer(answer: self.stepAnswer!, forKey: self.key)
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
