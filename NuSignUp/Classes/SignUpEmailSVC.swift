//
//  SignUpEmailSVC.swift
//  Upme-Professional
//
//  Created by José Lucas Souza das Chagas on 06/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit

class SignUpEmailSVC: SignUpNameSVC {
    
    private var defaultMessage:String?
    private var defaultColor:UIColor?
    
    private var isServerSideValid:Bool = false
    private var lastInvalidEmails:[String] = [String]()
    
    //private var emailKey:String = ProfAccount_Keys.email

    
    override func viewDidLoad() {
        key = ProfAccount_Keys.email
        defaultMessage = answerInfoTF.text
        defaultColor = answerInfoTF.textColor
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
    
    private func showAnswerInfoErrMessage(_ message:String="Esse email está em uso"){
        self.answerInfoTF.text = message//"Email em uso"
        self.answerInfoTF.textColor = RequestState.canceled.colorForState()
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.textColor = defaultColor
    }
    
    
    private func addStepAnswer(){
        delegate.addStepAnswer(answer: answerTF.text!, forKey: key)
    }
    
    
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
    
    private func validateEmailOnServer(){
        
        self.loadingMode(Loading: true)
        showActivity()
        //let alert = UIView.showLoadingAlert(OnVC: self, WithTitle: "Validando")
        //ActivityIndicatorHelper.showLoadingActivity(AtView: self.view, withDetailText: "Validando", animated: true)
        
        Professional_CRUD.checkAvailabilityOf(key: key, value: self.answerTF.text!) { (success, isAvailable) in
            DispatchQueue.main.async {
                self.hideActivity()
                self.loadingMode(Loading: false)
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
                        self.showAnswerInfoErrMessage("Esse email está em uso")
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        UIView.showAlert(OnVC: self, WithTitle:nil , Message: "Esse email está em uso. Experimente outro", AndActions: [okAction])
                    }
                }
                else{
                    self.answerTF.becomeFirstResponder()
                    //self.lastInvalidEmails.append(self.answerTF.text!)
                    //self.showAnswerInfoErrMessage()
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    UIView.showAlert(OnVC: self, WithTitle:nil , Message: "Ocorreu um problema na validação", AndActions: [okAction])
                }
            }
        }
        
        
    }
    
    //MARK: - SignUpStepProtocol methods
    
    
    override func shouldPresentNextStepButton() -> Bool {
        if let text = answerTF.text{
            return SignUpValidations.isAValidEmailFormat(emailString: text) && !lastInvalidEmails.contains(text)
        }
        return false
    }
    
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

    private func setUpTextField(){
        if let answers = delegate.answers{
            self.answerTF.text = answers[ProfAccount_Keys.email] as? String
        }
    }
    
    override func didChangeText(_ sender: Any) {
        super.didChangeText(sender)
        self.isServerSideValid = false
        updateAnswerInfoMessage()
    }
}
