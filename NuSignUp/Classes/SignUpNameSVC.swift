//
//  SignUpNameSVC.swift
//
//  Created by José Lucas Souza das Chagas on 24/05/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import InputMask

open class SignUpNameSVC: SignUpStepVC,MaskedTextFieldDelegateListener {

    @IBOutlet weak public var answerTF: UITextField!
    /**
     Some aditional information about the necessary answer.
     */
    @IBOutlet weak public var answerInfoTF: UILabel!

    /**
     The key for the respective answer
     */
    @IBInspectable public var key:String!

    @IBInspectable public var forceCapitalizeWords:Bool = false

    /**
     Mask format you want to apply on text answer, accordingly to 'InputMask' lib
     */
    @IBInspectable public var mask:String?{
        didSet{
            setUpDelegates()
        }
    }
    
    public var stepAnswer:String?{
        get{
            guard let _ = mask else{
                return answerTF.text
            }
            return _extractedAnswer
        }
    }
    
    private var _extractedAnswer:String? = ""
    /**
     Minimum number of characters the answer has to contain
     If you define a mask this value will has the same value of 
     
     'MaskedTextFieldDelegate.acceptableTextLength'
     */
    @IBInspectable public var minCharacters:Int = 0
    
    private var maskDelegate:MaskedTextFieldDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        self.didChangeStepAnswers()
        // Do any additional setup after loading the view.
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        answerTF.becomeFirstResponder()
    }

    override open func didReceiveMemoryWarning() {
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
    
    //MARK: - NameSVC
    override open func loadingMode(Loading loading: Bool) {
        super.loadingMode(Loading: loading)
        self.answerTF.isEnabled = !loading
    }
    
    open func showValidationActivity(){
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.startAnimating()
        self.answerTF.rightView = view
        self.answerTF.rightViewMode = .always
    }
    
    open func hideValidationActivity(){
        self.answerTF.rightView = nil
        self.answerTF.rightViewMode = .never
    }
    
    //MARK: - SignUpStepController methods
    override open func didTapNextStepButton(button: UIButton) {
        super.didTapNextStepButton(button: button)
        print("Add answer on answers")
        let answer = forceCapitalizeWords ? stepAnswer!.capitalized : stepAnswer!
        delegate.addStepAnswer(answer: answer, forKey: self.key)
        goToNextStep()
    }
    
    override open func shouldPresentNextStepButton() -> Bool {
        if let text = stepAnswer{
            return text.count >= minCharacters
        }
        return false
    }
    
    //MARK: - UITextField methods
    private func setUpDelegates(){
        if  let mask = mask{
            maskDelegate = MaskedTextFieldDelegate(format: mask)
            maskDelegate?.listener = self
            minCharacters = maskDelegate?.acceptableValueLength() ?? 0
            if answerTF != nil{
                answerTF.delegate = maskDelegate
            }
        }
        else{
            maskDelegate = nil
        }
    }
    
    
    private func setUpTextField(){
        setUpDelegates()
        let subKeys:[String] = self.key.components(separatedBy: "->")
        let k = subKeys.last!
        var values = self.delegate.answers
        
        if let _ = values{
            for pos in 0..<subKeys.count - 1{
                let currentKey = subKeys[pos]
                if let v = values![currentKey] as? [String:Any]{
                    values = v
                }
                else{
                    return
                }
            }
            
            if let values = values, let answer = values[k] as? String{
                if let maskDelegate = maskDelegate{
                    maskDelegate.put(text: answer, into: answerTF)//answers[key] as? String
                    _extractedAnswer = answer
                }
                else{
                    answerTF.text = answer
                }
            }
        }
    }
    
    @IBAction open func didChangeText(_ sender: Any) {
        self.didChangeStepAnswers()
    }
    
    //MARK: - MaskedTextFieldDelegateListener methods
    
    public func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        _extractedAnswer = value
        self.didChangeStepAnswers()
    }
    
}
