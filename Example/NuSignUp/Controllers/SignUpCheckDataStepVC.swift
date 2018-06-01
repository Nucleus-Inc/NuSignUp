//
//  SignUpCheckDataStepVC.swift
//
//  Created by Nucleus on 24/07/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

public protocol SignUpCheckDataStepC{
    
    /**
     Used to avoid user changing its informations after sending them to server
     */
    var canEdit:Bool{get set}
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    func didTapNextStep(_ answers:[String:Any],onVC vc:UIViewController,completion:@escaping(_ success:Bool,_ responseDict:[String:Any]?)->())
    
    func numberOfSections(Answers answers:[String:Any])->Int
    
    func numberOfRows(Answers answers:[String:Any],Section section:Int)->Int
    
    func dataFor(Answers answers:[String:Any],AtIndexPath indexPath:IndexPath)->(key:String,value:String?)
    
    func titleForHeader(Answers answers:[String:Any], InSection section:Int)->String?
    
    func didSelectAnswerAt(IndexPath indexPath:IndexPath,onVC vc:UIViewController,fromAnswers answers:[String:Any])
    
}

class SignUpCheckDataStepVC: SignUpStepVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var answersTableView: UITableView!
    
    public var controller:SignUpCheckDataStepC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = delegate.reviewMode == .none
        self.answersTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != SignUpStepSegues.nextStep.rawValue{
            var vc = segue.destination as! SignUpStepController
            vc.delegate.reviewMode = .step_pop
            vc.delegate.finishReviewBlock = {
                answers in
                self.delegate.answers = answers
                self.answersTableView.reloadData()
            }
        }
        
        controller.prepare(for: segue, sender: sender)
        
        
        super.prepare(for: segue, sender: sender)
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    private func updateNextStepTitle(_ title:String){
        self.nextStepButton.setTitle(title, for: .normal)
    }


    //MARK: - SignUpStep
    

    override func didTapNextStepButton(button: UIButton) {
        if controller.canEdit{
            self.loadingMode(Loading: true)
            
            let alert = UIAlertController(title: "Enviando", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            //ActivityIndicatorHelper.showLoadingActivity(AtView: self.view, withDetailText: "Enviando", animated: true)
            
            controller.didTapNextStep(delegate.answers!, onVC: self) { (success, responseDict) in
                DispatchQueue.main.async {
                    //ActivityIndicatorHelper.hideActivity(AtView: self.view, animated: true)
                    alert.dismiss(animated: true, completion: {
                        self.loadingMode(Loading: false)
                        if success{
                            self.goToNextStep()
                        }
                        else{
                            self.updateNextStepTitle("Tentar Novamente")
                        }
                    })
                }
            }
        }
        else{
            self.goToNextStep()
        }
    }
    
    //MARK: - UITableView methods
    
    private func setUpTableView(){
        answersTableView.delegate = self
        answersTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.numberOfSections(Answers: delegate.answers!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.numberOfRows(Answers: delegate.answers!, Section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tuple = controller.dataFor(Answers: delegate.answers!, AtIndexPath: indexPath)
        
        let cell = self.answersTableView.dequeueReusableCell(withIdentifier: "answerCell")!

        cell.textLabel?.text = tuple.key
        
        cell.detailTextLabel?.text = tuple.value

        /*if indexPath.row < answers!.keysArray().count{
            cell.indentationLevel = -10000
            cell.separatorInset.left = 100000
        }*/
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return controller.titleForHeader(Answers: delegate.answers!, InSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if controller.canEdit{
            controller.didSelectAnswerAt(IndexPath: indexPath, onVC: self, fromAnswers: delegate.answers!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
