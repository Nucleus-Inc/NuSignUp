//
//  SignUpNameSVC.swift
//
//  Created by José Lucas Souza das Chagas on 24/05/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit

open class SignUpNameSVC: SignUpStepVC {

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
     Regex to test the answer
     */
    @IBInspectable public var regex:String?
    
    public var stepAnswer:String?{
        return answerTF.text
    }
    
    /**
     Minimum number of characters the answer has to contain
     */
    @IBInspectable public var minCharacters:Int = 0
    
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
            guard let regex = regex else{
                return text.count >= minCharacters
            }
            //http://nshipster.com/nsregularexpression/
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            let matches = predicate.evaluate(with: text)
            return text.count >= minCharacters && matches
        }
        return false
    }
    
    //MARK: - UITextField methods

    private func setUpTextField(){
        answerTF.text = delegate.answer(ForKey: key) as? String
    }
    
    @IBAction open func didChangeText(_ sender: Any) {
        self.didChangeStepAnswers()
    }
    
}
