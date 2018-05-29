//
//  SignUpPasswordSVC.swift
//  Upme-Professional
//
//  Created by Nucleus on 07/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit


class SignUpPasswordSVC: SignUpStepVC, UITextFieldDelegate {
    @IBOutlet weak var answerTF: UITextField!

    @IBOutlet weak var confirmationTF: UITextField!

    @IBOutlet weak var seePasswordButton: UIButton!

    @IBOutlet weak var confirmInfoLabel: UILabel!
    private var defaultConfirmMessage:String?
    private var defaultConfirmColor:UIColor?
    
    @IBOutlet weak var answerInfoLabel: UILabel!
    private var defaultPInfoMessage:String?
    private var defaultPInfoColor:UIColor?

    
    @IBOutlet weak var passwordStrengthView: JLProgressView!
    
    private var key:String = ProfAccount_Keys.password
    private var scoreForPassword:[String:Int] = [:]
    @IBInspectable var minCharacters:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        setUpLabels()
        didChangeStepAnswers()
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
    
    //MARK: - PasswordSVC
    private func addStepAnswer(){
        delegate.addStepAnswer(answer: answerTF.text!, forKey: key)
    }
    
    
    private func updateStrengthView(ForScore score:Int,AndPassword password:String){
        var color:UIColor!
        var value:Int = score
        var message:String!
        
        switch score {
        case 0:
            color = UIColor(red: 200/255, green: 38/255, blue: 71/255, alpha: 1)//.red
            message = "Fraca"
        case 1:
            color = UIColor(red: 200/255, green: 38/255, blue: 71/255, alpha: 1)//.red
            message = "Fraca"
        case 2:
            color = UIColor(red: 254/255, green: 193/255, blue: 6/255, alpha: 1)
            message = "Regular"
        case 3:
            color = UIColor(red: 254/255, green: 193/255, blue: 6/255, alpha: 1)
            message = "Regular"
        case 4:
            color = UIColor(red: 113/255, green: 186/255, blue: 81/255, alpha: 1)
            message = "Forte"
        default:
            color = UIColor(red: 113/255, green: 186/255, blue: 81/255, alpha: 1)
        }
        
        self.scoreForPassword[password] = score
        
        if password.count < self.minCharacters{
            value = 0
            color = UIColor(red: 200/255, green: 38/255, blue: 71/255, alpha: 1)//.red
            message = "Muito Curta"
        }
        
        self.passwordStrengthView.updateToStep(value + 1, WithColor: color)
        self.updateAnswerInfoLabel(text: message, textColor: color)
    }
    
    private func updatePasswordStrength(){

        if  let password = answerTF.text, password != "" {
            
            if let score = scoreForPassword[password]{
                updateStrengthView(ForScore: score,AndPassword: password)
                super.didChangeStepAnswers()
            }
            else{
                
                UpmeGeneral_CRUD.checkStrength(Password: password, completion: { (success, score) in
                    
                    DispatchQueue.main.async {
                        if success{
                            print(password+" score: \(score)")
                            self.updateStrengthView(ForScore: score,AndPassword: password)
                        }
                        else{
                            self.passwordStrengthView.updateToStep(0, WithColor: nil)
                            self.updateAnswerInfoLabel(text: self.defaultPInfoMessage, textColor: self.defaultPInfoColor!)
                        }
                        super.didChangeStepAnswers()
                    }
                })
                
            }
            
        }
        else{
            passwordStrengthView.updateToStep(0, WithColor: nil)
            updateAnswerInfoLabel(text: defaultPInfoMessage, textColor: defaultPInfoColor!)
            super.didChangeStepAnswers()
        }
        
        
    }

    
    private func checkEquality()->Bool{
        if let text = answerTF.text{
            if let confirmationText = confirmationTF.text{
                return confirmationText.compare(text) == ComparisonResult.orderedSame
            }
        }
        return false
    }
    
    @IBAction func seePasswordAction(_ sender: Any) {
        seePasswordButton.isSelected = !seePasswordButton.isSelected
        answerTF.isSecureTextEntry = !seePasswordButton.isSelected
        confirmationTF.isSecureTextEntry = !seePasswordButton.isSelected
    }
    
    //MARK: - SignUpStepController methods
    
    override func didTapNextStepButton(button: UIButton) {
        super.didTapNextStepButton(button: button)
        print("Add answer on answers")
        if checkEquality(){
            addStepAnswer()
            goToNextStep()
        }
        else{
            let okAction  =  UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.confirmationTF.becomeFirstResponder()
            })
            
            UIView.showAlert(OnVC: self, WithTitle: nil, Message: "Os valores não correspondem", AndActions: [okAction])
        }
    }
    
    override func didChangeStepAnswers() {
        updateConfirmLabel()
        if !answerTF.isEditing{
            updatePasswordStrength()
        }
    }
    
    override func shouldPresentNextStepButton() -> Bool {
        if let text = answerTF.text, text.count >= minCharacters{
            if let score = scoreForPassword[text]{
                return score > 1 && checkEquality()
            }
            return false
        }
        return false
    }

    //MARK: - UILabel methods
    
    private func setUpLabels(){
        defaultConfirmMessage = confirmInfoLabel.text
        defaultConfirmColor = confirmInfoLabel.textColor
        
        defaultPInfoColor = answerInfoLabel.textColor
        defaultPInfoMessage = answerInfoLabel.text
    }
    
    private func updateAnswerInfoLabel(text:String?,textColor:UIColor){
        answerInfoLabel.textColor = textColor
        answerInfoLabel.text = text
    }
    
    private func updateConfirmLabel(){
        if checkEquality() || !confirmationTF.isEditing{
            confirmInfoLabel.text = defaultConfirmMessage
            confirmInfoLabel.textColor = defaultConfirmColor
        }
        else{
            confirmInfoLabel.textColor = RequestState.canceled.colorForState()
            confirmInfoLabel.text = "Os valores não correspondem"
        }
    }
    
    //MARK: - UITextField methods
    
    private func setUpTextField(){
        answerTF.delegate = self
        confirmationTF.delegate = self
        if let answers = delegate.answers{
            self.answerTF.text = answers[key] as? String
            self.confirmationTF.text = answers[key] as? String
        }
    }
    

    
    @IBAction func didChangeText(_ sender: Any) {
        self.didChangeStepAnswers()
    }
    
    //MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{//answerTF
            confirmationTF.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.didChangeStepAnswers()
    }
    
}
