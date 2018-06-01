//
//  SignUpCodeSVC.swift
//
//  Created by José Lucas Souza das Chagas on 07/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import InputMask
import NuSignUp

enum CodeTransport:String{
    case sms = "sms"
    case email = "email"
}

class SignUpCodeSVC: SignUpStepVC,MaskedTextFieldDelegateListener {
    @IBOutlet weak var sendAgainButton: UIButton!

    @IBOutlet weak var questionInfoLabel: UILabel!
    
    @IBOutlet var codeTFs: [UITextField]!
    
    @IBOutlet weak var answerInfoTF: UILabel!
    
    private var defaultMessage:String?
    private var defaultColor:UIColor?
    
    @IBInspectable var minCharacters:Int = 0
    
    private var maskDelegate:MaskedTextFieldDelegate?
    var lastInvalidCodes:[String] = []

    private var codeDelegate:SignUpCodeDelegate = SignUpCodeDelegate()
        
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = codeDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = codeDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultMessage = answerInfoTF.text
        defaultColor = answerInfoTF.textColor
        setUpTextField()
        setUpQuestionInfoLabel()
        self.didChangeStepAnswers()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeTFs[0].becomeFirstResponder()
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
        
        sendCodeAgain()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.reviewMode = .none
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
    
    //MARK: - CodeSVC
    
    private func clearCode(){
        for codeTF in codeTFs{
            codeTF.text = nil
        }
    }
    
    private func typedCode()->String?{
        var code:String?
        for codeTF in codeTFs{
            if let number = codeTF.text{
                if let c = code{
                    code = c + number
                }
                else{
                    code = number
                }
            }
        }
        return code
    }

    private func updateAnswerInfoMessage(){
        if let code = typedCode(){
            lastInvalidCodes.contains(code) ? showAnswerInfoErrMessage() : showAnswerInfoDefaultMessage()
        }
        else{
            showAnswerInfoDefaultMessage()
        }
    }
    
    private func showAnswerInfoErrMessage(){
        self.answerInfoTF.text = "Invalid code"
        self.answerInfoTF.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.textColor = defaultColor
    }

    
    @IBAction func codeNotReceivedAction(_ sender: UIButton) {

        let alertC = UIAlertController(title: "Validation", message: "Send code again", preferredStyle: .actionSheet)
        
        if let unmaskedNumber = self.delegate.answers!["phoneNumber"] as? String{
            let toNumber = UIAlertAction(title: "SMS - "+unmaskedNumber, style: .default) { (_) in
                self.sendCodeAgain(By:.sms)
            }
            alertC.addAction(toNumber)
        }
        
        if let email = self.delegate.answers!["email"] as? String{
            let toEmail = UIAlertAction(title: "Email - "+email, style: .default) { (_) in
                self.sendCodeAgain(By:.email)
            }
            alertC.addAction(toEmail)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in}
        alertC.addAction(cancel)
        
        if let popoverController = alertC.popoverPresentationController {// IPAD
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(alertC, animated: true, completion: nil)
        
    }
    
    //MARK: - Server methods
    override func loadingMode(Loading loading: Bool) {
        super.loadingMode(Loading: loading)
        sendAgainButton.isEnabled = !loading
        for tfs in codeTFs{
            tfs.isEnabled = !loading
        }
    }

    internal func sendCodeAgain(By by:CodeTransport = .sms){
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            LocalNotification.showValidationCodeNotif(WithCode: "1239")
        }
    }
    
    /**
     This method tries to validate the current account with typed code
     */
    private func validateAccount(){
        let alert = UIAlertController(title: "Validating", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        self.loadingMode(Loading: true)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let success = true
            let validCode = true
            DispatchQueue.main.async {
                self.codeDelegate.isServerSideValid = validCode
                alert.dismiss(animated: true, completion: {
                    
                    self.loadingMode(Loading: false)
                    
                    if success && validCode{
                        UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "Account Validation", Message: "Your account was validated with success.", OKAction: { (_) in
                            self.goToNextStep()
                        })
                    }
                    else{
                        
                        if !validCode{
                            self.lastInvalidCodes.append(self.typedCode()!)
                            self.clearCode()
                        }
                        else{
                            UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "Error", Message: "It was not possible to validate your account.")
                        }
                    }
                    
                    self.updateAnswerInfoMessage()
                    
                })
                
            }
        }
    }
    
    

    //MARK: - SignUpStepController methods
    
    override func didChangeStepAnswers() {
        super.didChangeStepAnswers()
        codeDelegate.isServerSideValid = false
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
        updateAnswerInfoMessage()
    }
    
    override func shouldPresentNextStepButton() -> Bool {
        if let text = typedCode(){
            return text.count == minCharacters && !lastInvalidCodes.contains(text)
        }
        return false
    }
    
    override func didTapNextStepButton(button: UIButton) {
        super.didTapNextStepButton(button: button)
        print("Add answer on answers")
        
        if !codeDelegate.isServerSideValid,  let text = typedCode() {
            if !lastInvalidCodes.contains(text){
                
                validateAccount()
                
            }
            else{
                self.codeTFs[0].becomeFirstResponder()
                
                UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "The code \(typedCode()!) is invalid.", Message: "Ask for a new code.")
                self.clearCode()
            }
        }
        else{
            goToNextStep()
        }
    }

    //MARK: - UILabel methods
    
    internal func setUpQuestionInfoLabel(){
        let number = (self.delegate.answers!["phoneNumber"] as! String)
        questionInfoLabel.text = "A SMS was send to the number "+number
    }

    //MARK: - UITextField methods
    private func setUpTextField(){
        maskDelegate = MaskedTextFieldDelegate(format: "[0]")
        maskDelegate?.autocomplete = false
        maskDelegate?.listener = self
        
        for codeTF in codeTFs{
            codeTF.delegate = self//maskDelegate
        }
    }
    
    @IBAction func didChangeText(_ sender: Any) {
        self.didChangeStepAnswers()
    }
    
    
    //MARK: - MaskedTextFieldDelegateListener methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        didChangeStepAnswers()

        if string == ""{
            let pos = textField.tag
            let newPos = pos - 1
            if newPos >= 0 {
                codeTFs[newPos].becomeFirstResponder()
            }
            maskDelegate?.put(text: string, into: textField)
        }
        else{
            if let text = textField.text, text != ""{
                let pos = textField.tag
                let newPos = pos + 1
                if newPos < 4{
                    maskDelegate?.put(text: string, into: codeTFs[newPos])
                    codeTFs[newPos].becomeFirstResponder()
                }
            }
            else{
                maskDelegate?.put(text: string, into: textField)
            }
            
        }
        return false
    }
    
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        didChangeStepAnswers()
    }
}

/**
 Override from the same class of 'SignUpConfig.baseStepsDelegate'
 */
class SignUpCodeDelegate:ExampleSignUpDelegate{
    
    var isServerSideValid:Bool = false
    
    required init() {
        super.init()
    }
    
    override func updateAppearanceOf(NextStepButton button: UIButton) {
        button.setTitle(isServerSideValid ? "Next" : "Validate", for: .normal)
    }
}
