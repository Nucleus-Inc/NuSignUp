//
//  SignUpCodeSVC.swift
//  Upme-Professional
//
//  Created by José Lucas Souza das Chagas on 07/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import InputMask

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
        self.answerInfoTF.text = "Código inválido"
        self.answerInfoTF.textColor = RequestState.canceled.colorForState()
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.textColor = defaultColor
    }

    
    @IBAction func codeNotReceivedAction(_ sender: UIButton) {

        let alertC = UIAlertController(title: "Validação", message: "Enviar código Novamente", preferredStyle: .actionSheet)
        
        if let unmaskedNumber = self.delegate.answers![ProfAccount_Keys.phone_number] as? String{
            let number = unmaskedNumber.replacingOccurrences(of: "55", with: "")
            let toNumber = UIAlertAction(title: "Por SMS - "+number, style: .default) { (_) in
                self.sendCodeAgain(By:.sms)
            }
            alertC.addAction(toNumber)
        }
        
        if let email = self.delegate.answers![ProfAccount_Keys.email] as? String{
            let toEmail = UIAlertAction(title: "Por Email - "+email, style: .default) { (_) in
                self.sendCodeAgain(By:.email)
            }
            alertC.addAction(toEmail)
        }

        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in}
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
        let jwtBodyDict = User.getBodyOfToken(User.getToken()!)!
        if let id = jwtBodyDict[JWT_Keys.id] as? String{
            Professional_CRUD.requestNewCode(ID: id,By: by, completion: { (success, jsonData) in
                if success{
                    print(jsonData ?? "sendCodeAgain - no data")
                }
                else{
                    print("ERROR")
                    print(jsonData ?? "sendCodeAgain - no data")
                }
            })
        }
    }
    
    /**
     This method tries to validate the current account with typed code
     */
    private func validateAccount(){
        
        //let alert = UIView.showLoadingAlert(OnVC: self, WithTitle: "Validando")
        let jwtBodyDict = User.getBodyOfToken(User.getToken()!)!

        if let id = jwtBodyDict[JWT_Keys.id] as? String{
            //ActivityIndicatorHelper.showLoadingActivity(AtView: self.view, withDetailText: "Verificando", animated: true)
            let alert = UIAlertController(title: "Verificando", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            self.loadingMode(Loading: true)
            
            Professional_CRUD.validateAccountWith(ID: id,Code:typedCode()!, completion: { (success,jsonData) in
                
                DispatchQueue.main.async {
                    self.codeDelegate.isServerSideValid = success
                    //ActivityIndicatorHelper.hideActivity(AtView: self.view, animated: true, async: true)
                    alert.dismiss(animated: true, completion: {
                        
                        self.loadingMode(Loading: false)
                        
                        if success{
                            
                            if let dict = jsonData, let professional = Professional(JSON: dict){
                                
                                UpmeSingleton.sharedInstance.professional = professional
                                
                                UpmeSingleton.sharedInstance.professional?.save(UpdateIfExists: true)
                                
                                UpmeSingleton.sharedInstance.cleanUpOtherProfessionalsData()
                                
                            }
                            
                            print("Open the app")
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (acion) in
                                self.goToNextStep()
                            })
                            
                            UIView.showAlert(OnVC: self, WithTitle: nil, Message: "Conta ativada com sucesso", AndActions: [okAction])
                        }
                        else{
                            
                            self.codeTFs[0].becomeFirstResponder()
                            if let data = jsonData{
                                if let code = RequestError.errorOnDict(data), code == RequestError.Code.AUT_005{
                                    self.lastInvalidCodes.append(self.typedCode()!)
                                }
                                RequestError.showAlertFor(data: data, onVC: self)
                            }
                            else{
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                UIView.showAlert(OnVC: self, WithTitle: "Erro", Message: "Não foi possivel validar a sua conta", AndActions: [okAction])
                            }
                            
                            self.clearCode()
                        }
                        
                        self.updateAnswerInfoMessage()

                    })
                    
                }
            })
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

    override func goToNextStep() {
        switch delegate.reviewMode {
        case .none:
            
            if let _ = UpmeSingleton.sharedInstance.professional{
                super.goToNextStep()
            }
            else{
                self.view.endEditing(true)
                self.navigationController!.dismiss(animated: true, completion: nil)
                /*if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                 appDelegate.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpmeTabBarC")
                }*/
            }
            
        default:
            super.goToNextStep()
        }
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
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                UIView.showAlert(OnVC: self, WithTitle:nil , Message: "O código \(typedCode()!) é inválido", AndActions: [okAction])
                self.clearCode()
            }
        }
        else{
            goToNextStep()
        }
    }

    //MARK: - UILabel methods
    
    internal func setUpQuestionInfoLabel(){
        let number = (self.delegate.answers![ProfAccount_Keys.phone_number] as! String).replacingOccurrences(of: "55", with: "")
        questionInfoLabel.text = "Um sms com o código foi enviado para o número "+(SignUpMask.brPhone.applyOnText(text: number))!
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

class SignUpCodeDelegate:DefaultSUpSDelegate{
    
    var isServerSideValid:Bool = false
    
    override func updateAppearanceOf(NextStepButton button: UIButton) {
        button.setTitle(isServerSideValid ? "Próximo" : "Verificar", for: .normal)
    }
}
