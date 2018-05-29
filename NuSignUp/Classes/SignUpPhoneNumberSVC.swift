//
//  SignUpPhoneNumberSVC.swift
//  Upme-Professional
//
//  Created by Nucleus on 08/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit

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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SignUpStepSegues.nextStep.rawValue{
            let vc = segue.destination as! SignUpCheckDataStepVC
            vc.controller = UpmeP1CheckDataStepC()
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: - PhoneNumberSVC
    private func updateAnswerInfoMessage(){
        lastInvalidNumbers.contains(stepAnswer!) ? showAnswerInfoErrMessage() : showAnswerInfoDefaultMessage()
    }
    
    private func showAnswerInfoErrMessage(){
        self.answerInfoTF.text = "Telefone já cadastrado"
        self.answerInfoTF.textColor = RequestState.canceled.colorForState()
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

        Professional_CRUD.checkAvailabilityOf(key: key, value: stepAnswer!) { (success, isAvailable) in
            DispatchQueue.main.async {
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
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        UIView.showAlert(OnVC: self, WithTitle:nil , Message: "Esse número está em uso. Experimente outro", AndActions: [okAction])
                    }
                }
                else{
                    self.answerTF.becomeFirstResponder()
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    UIView.showAlert(OnVC: self, WithTitle:nil , Message: "Ocorreu um problema na validação", AndActions: [okAction])
                }
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
                /*let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                 UIView.showAlert(OnVC: self, WithTitle:nil , Message: "Email já cadastrado", AndActions: [okAction])*/
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
