//
//  SignUpStepVC.swift
//  Upme-Professional
//
//  Created by José Lucas Souza das Chagas on 24/05/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit

class SignUpStepVC: UIViewController,SignUpStepController {
    
    
    @IBOutlet weak var nextStepButton: UIButton!
    
    @IBOutlet weak var buttonDistToBottom: NSLayoutConstraint!
    
    @IBInspectable var stepNumber:Int = 0
    
    @IBInspectable var isOptional: Bool = false{
        didSet{
            delegate.isOptional = isOptional
        }
    }
    
    var showBackgroundImg:Bool = true
    
    var delegate: SignUpStepDelegate = DefaultSUpSDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackBtn()
        delegate.setUpNextStepButton(button: nextStepButton)
        if showBackgroundImg{
            backgroundImg()
        }
        //setUpNavigationAppearance()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setUpNavigationAppearance()
        startListeningKeyboard()
        if let navc = self.navigationController as? SignUpNavigationC{
            navc.updateForStep(step: stepNumber)
        }
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpBackBtn(){
        if stepNumber <= 1 && delegate.reviewMode == .none{
            let closeAllBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(SignUpStepVC.closeAllBtnAction(sender:)))
            self.navigationItem.leftBarButtonItem = closeAllBtn
        }
    }
    
    @objc
    private func closeAllBtnAction(sender:Any){
        let yesAction = UIAlertAction(title: "Sim", style: .default) { (_) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "Não", style: .cancel, handler: nil)
        let alertC = UIAlertController(title: "Cancelar Cadastro", message: "Você perderá as informações adicionadas nessa etapa do cadastro.\n\n Deseja Continuar mesmo assim?", preferredStyle: .alert)
        alertC.addAction(yesAction)
        alertC.addAction(noAction)
        self.present(alertC, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    //MARK: - Background
    private func backgroundImg(){
        let image = UIImage(named: "img-login")
        let imgView = UIImageView(image: image)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imgView)
        imgView.alpha = 1
        self.view.sendSubview(toBack: imgView)
        
        let topC = NSLayoutConstraint(item: imgView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        self.view.addConstraint(topC)
        
        let bottomC = NSLayoutConstraint(item: imgView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottomC)
        
        let leadingC = NSLayoutConstraint(item: imgView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        self.view.addConstraint(leadingC)
        
        let trailingC = NSLayoutConstraint(item: imgView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        self.view.addConstraint(trailingC)
        
        
    }
    
    //MARK: - SignUpStepVC methods
    
    public func loadingMode(Loading loading:Bool){
        //self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = !loading
        //self.navigationController?.navigationBar.isUserInteractionEnabled = !loading
        self.nextStepButton.isEnabled = !loading
    }
    
    //MARK: - SignUpStepController Methods
    
    /**
     This method works with your implementation of 'shouldPresentNextStepButton' to present or not 'nextStepButton'
     */
    func didChangeStepAnswers() {
        shouldPresentNextStepButton() || delegate.isOptional ? delegate.presentNextStepButton(button: nextStepButton) : delegate.hideNextStepButton(button: nextStepButton)
    }
    
    
    func didTapNextStepButton(button: UIButton) {
        //TODO: Add your own implementation here, its a good place to add some remote verification, for example of CPF, inform user about some error and call 'goToNextStep()'
    }
    
    func goToNextStep() {
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
    func shouldPresentNextStepButton() -> Bool {
        //TODO: Add your own implementation process for this step.
        return delegate.isOptional
    }
    
    //MARK:KeyboardListener methods
    
    
    override func keyboardWillAppear(keyboardInfo: [String : Any]) {
        
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
    
    
    override func keyboardWillDisappear(keyboardInfo: [String : Any]) {
        let animationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]
        buttonDistToBottom.constant = 5
        UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            
        })
    }
    
}
