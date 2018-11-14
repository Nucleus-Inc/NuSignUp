//
//  SignUpEmailSVC.swift
//
//  Created by José Lucas Souza das Chagas on 06/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class SignUpEmailSVC: SignUpNameSVC {
    
    private var defaultMessage:String?
    
    private var isServerSideValid:Bool = false
    private var lastInvalidEmails:[String] = [String]()
    
    //private var emailKey:String = ProfAccount_Keys.email

    
    override func viewDidLoad() {
        key = "email"
        defaultMessage = answerInfoTF.text
        super.viewDidLoad()
        setUpTextField()
        //self.didChangeStepAnswers()
        // Do any additional setup after loading the view.
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        answerTF.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: EmailSVC
    override func loadingMode(Loading loading: Bool) {
        super.loadingMode(Loading: loading)
        self.answerTF.isEnabled = !loading
    }
    
    private func updateAnswerInfoMessage(){
        lastInvalidEmails.contains(answerTF.text!) ? showAnswerInfoErrMessage() : showAnswerInfoDefaultMessage()
    }
    
    private func showAnswerInfoErrMessage(_ message:String="This email is in use."){
        self.answerInfoTF.text = message//"Email em uso"
        self.answerInfoTF.style = .error
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.style = .normal
    }
    
    
    private func addStepAnswer(){
        delegate.addStepAnswer(answer: answerTF.text!, forKey: key)
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
    
    private func validateEmailOnServer(){
        
        self.loadingMode(Loading: true)
        showActivity()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.hideActivity()
            self.loadingMode(Loading: false)
            let success = true
            let isAvailable = true
            
            if success{
                if isAvailable{
                    
                    self.isServerSideValid = true
                    print("Add answer on answers")
                    self.addStepAnswer()
                    self.goToNextStep()
                    
                }
                else{
                    self.answerTF.becomeFirstResponder()
                    self.isServerSideValid = false
                    self.lastInvalidEmails.append(self.answerTF.text!)
                    self.showAnswerInfoErrMessage("This email is in use")

                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: nil, Message: "This email is in use. Try another one.", OKAction: nil)
                }
            }
            else{
                self.answerTF.becomeFirstResponder()

                UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: nil, Message: "It was not possible to validate your email.", OKAction: nil)
            }
        }
    }
    
    //MARK: - SignUpStepProtocol methods
    
    /*
    override func shouldPresentNextStepButton() -> Bool {
        if let text = answerTF.text{
            return SignUpValidations.isAValidEmailFormat(emailString: text) && !lastInvalidEmails.contains(text)
        }
        return false
    }
    */
    override func didTapNextStepButton(button: UIButton) {
        if !isServerSideValid {
            if let answer = answerTF.text, !lastInvalidEmails.contains(answer){
                //testa
                validateEmailOnServer()
            }
            else{
                /*let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                UIView.showAlert(OnVC: self, WithTitle:nil , Message: "Email já cadastrado", AndActions: [okAction])*/
                self.showAnswerInfoErrMessage()
            }
        }
        else{
            print("Add answer on answers")
            addStepAnswer()
            goToNextStep()
        }
        
    }
    
    //MARK: - UITextField methods

    override func setUpTextField(){
        if let answers = delegate.answers{
            self.answerTF.text = answers[key] as? String
        }
    }
    
    override func didChangeText(_ sender: Any) {
        super.didChangeText(sender)
        self.isServerSideValid = false
        updateAnswerInfoMessage()
    }
}
