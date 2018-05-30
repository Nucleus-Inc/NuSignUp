//
//  SignUpStepVC.swift
//
//  Created by José Lucas Souza das Chagas on 24/05/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit

open class SignUpStepVC: UIViewController,SignUpStepController {
    
    
    @IBOutlet weak public var nextStepButton: UIButton!
    
    @IBOutlet weak public var buttonDistToBottom: NSLayoutConstraint!
    
    @IBInspectable public var stepNumber:Int = 0
    
    @IBInspectable public var isOptional: Bool = false{
        didSet{
            delegate.isOptional = isOptional
        }
    }
    
    public var delegate: SignUpStepDelegate = SignUpStack.config.newDelegateInstance()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        delegate.setUpNextStepButton(button: nextStepButton)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setUpNavigationAppearance()
        startListeningKeyboard()
        if let navc = self.navigationController as? SignUpStackC{
            navc.updateForStep(step: stepNumber)
        }
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningKeyboard()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let step = segue.destination as? SignUpStepController{
            step.delegate.answers = delegate.answers
        }
        else if let navStep = segue.destination as? UINavigationController, let _ = navStep.viewControllers[0] as? SignUpStepController{
            //step.answers = answers
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func nextStepAction(_ sender: UIButton) {
        didTapNextStepButton(button: sender)
    }
    
    //MARK: - SignUpStepVC methods
    
    open func loadingMode(Loading loading:Bool){
        //self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = !loading
        //self.navigationController?.navigationBar.isUserInteractionEnabled = !loading
        self.nextStepButton.isEnabled = !loading
    }
    
    //MARK: - SignUpStepController Methods
    
    /**
     This method works with your implementation of 'shouldPresentNextStepButton' to present or not 'nextStepButton'
     */
    open func didChangeStepAnswers() {
        shouldPresentNextStepButton() || delegate.isOptional ? delegate.presentNextStepButton(button: nextStepButton) : delegate.hideNextStepButton(button: nextStepButton)
    }
    
    
    open func didTapNextStepButton(button: UIButton) {
        //TODO: Add your own implementation here, its a good place to add some remote verification, for example of CPF, inform user about some error and call 'goToNextStep()'
    }
    
    open func goToNextStep() {
        let reviewMode = self.delegate.reviewMode
        let answers = delegate.answers
        switch reviewMode {
        case .section:
            self.performSegue(withIdentifier: SignUpStepSegues.reviewSectionNextStep.rawValue, sender: answers)
        case .step_push:
            self.performSegue(withIdentifier: SignUpStepSegues.reviewStepNextStep.rawValue, sender: answers)
        case .step_pop:
            if let nav = self.navigationController{
                nav.popViewController(animated: true)
            }
            else{
                self.dismiss(animated: true, completion: nil)
            }
            
            if let block = delegate.finishReviewBlock{
                block(answers)
            }
            
        default:
            self.performSegue(withIdentifier: SignUpStepSegues.nextStep.rawValue, sender: answers)
        }
    }
    
    /**
     You must override this method if you want a diferent approach.
     */
    open func shouldPresentNextStepButton() -> Bool {
        //TODO: Add your own implementation process for this step.
        return delegate.isOptional
    }
    
    //MARK:KeyboardListener methods
    
    
    override open func keyboardWillAppear(keyboardInfo: [String : Any]) {
        
        if let keyBoardFrame = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue{
            let animationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]
            
            let bottomY  = self.view.frame.height - self.buttonDistToBottom.constant
            let quantToMove = (bottomY + 5) - keyBoardFrame.origin.y - self.navigationController!.navigationBar.frame.height
            
            buttonDistToBottom.constant += quantToMove + nextStepButton.frame.height //+ 20
            UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
                self.view.layoutIfNeeded()
            }, completion: {(finished) in
                
            })
            
        }
        
    }
    
    
    override open func keyboardWillDisappear(keyboardInfo: [String : Any]) {
        let animationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]
        buttonDistToBottom.constant = 5
        UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            
        })
    }
    
}
