//
//  SignUpNameSVC.swift
//  Upme-Professional
//
//  Created by José Lucas Souza das Chagas on 24/05/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import InputMask

class SignUpNameSVC: SignUpStepVC,MaskedTextFieldDelegateListener {

    @IBOutlet weak var answerTF: UITextField!
    /**
     Some aditional information about the necessary answer.
     */
    @IBOutlet weak var answerInfoTF: UILabel!

    /**
     The key for the respective answer
     */
    @IBInspectable var key:String!

    @IBInspectable var forceCapitalizeWords:Bool = false

    /**
     Mask format you want to apply on text answer, accordingly to 'InputMask' lib
     */
    @IBInspectable var mask:String?{
        didSet{
            setUpDelegates()
        }
    }
    
    var stepAnswer:String?{
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
    @IBInspectable var minCharacters:Int = 0
    
    private var maskDelegate:MaskedTextFieldDelegate?

    public var nameDelegate:DefaultSignNameDelegate = DefaultSignNameDelegate()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = nameDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = nameDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        self.didChangeStepAnswers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
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
    
    //MARK: - NameSVC
    override func loadingMode(Loading loading: Bool) {
        super.loadingMode(Loading: loading)
        self.answerTF.isEnabled = !loading
    }
    
    public func showValidationActivity(){
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.startAnimating()
        self.answerTF.rightView = view
        self.answerTF.rightViewMode = .always
    }
    
    public func hideValidationActivity(){
        self.answerTF.rightView = nil
        self.answerTF.rightViewMode = .never
    }
    
    //MARK: - SignUpStepController methods
    override func didTapNextStepButton(button: UIButton) {
        super.didTapNextStepButton(button: button)
        print("Add answer on answers")
        let answer = forceCapitalizeWords ? stepAnswer!.capitalized : stepAnswer!
        delegate.addStepAnswer(answer: answer, forKey: self.key)
        goToNextStep()
    }
    
    override func shouldPresentNextStepButton() -> Bool {
        if let text = stepAnswer{
            return text.count >= minCharacters
        }
        return false
    }
    
    //MARK: - SignUpStepProtocol methods
    /*
    /**
     The default implementation of this method changes its title from 'Próximo' to 'Pronto' when reviewMode != .none
     */
    override func updateAppearanceOf(NextStepButton button: UIButton) {
        if reviewMode != .none{
            self.nextStepButton.setTitle("Pronto", for: .normal)
        }
        else{
            self.nextStepButton.setTitle("Próximo", for: .normal)
        }
    }
    
    override func shouldPresentNextStepButton() -> Bool {
        if let text = stepAnswer{
            return text.count >= minCharacters
        }
        return false
    }
    
    override func didTapNextStepButton(button: UIButton) {
        super.didTapNextStepButton(button: button)
        print("Add answer on answers")
        
        addStepAnswer()
        
        goToNextStep()
    }
    */
    
    
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
    
    @IBAction func didChangeText(_ sender: Any) {
        self.didChangeStepAnswers()
    }
    
    //MARK: - MaskedTextFieldDelegateListener methods
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        _extractedAnswer = value
        self.didChangeStepAnswers()
    }
    
}

class DefaultSignNameDelegate:DefaultSUpSDelegate{
    /**
     The default implementation of this method changes its title from 'Próximo' to 'Pronto' when reviewMode != .none
     */
    override func updateAppearanceOf(NextStepButton button: UIButton) {
        if reviewMode != .none{
            button.setTitle("Pronto", for: .normal)
        }
        else{
            button.setTitle("Próximo", for: .normal)
        }
    }
}
