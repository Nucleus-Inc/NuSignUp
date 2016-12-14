//
//  ViewController.swift
//  NuLikeSignUp
//
//  Created by Nucleus on 12/05/2016.
//  Copyright (c) 2016 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class ViewController: UIViewController,RegisterDataSource,RegisterDelegate {
    

    
    @IBOutlet weak var registerTableV: RegisterTableView!
    
    @IBOutlet weak var nextButton: RegisterButton!
    
    @IBOutlet weak var previousButton: UIButton!

    
    let numberOfQuestions:Int = 4
    
    var questionsOrder:[String] = ["yourNameQuestion","yourLastNameQuestion","yourAgeQuestion","civilStateQuestion"]
    
    var answers:[Any] = [Any?](repeating: nil, count: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableV.regDataSource = self
        registerTableV.regDelegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextQuestionAction(_ sender: UIButton) {
        
        self.registerTableV.goToNextQuestion()
        
    }
    
    @IBAction func previusQuestionAction(_ sender: UIButton) {
        self.registerTableV.goToPreviousQuestion()
    }
    
    
    //MARK: - RegisterDelegate methods
    
    public func answer(answer: Any?, Isvalid valid: Bool, ForQuestionCellAtPosition position: Int) {
        
        if valid {
            answers[position] = answer
            self.nextButton.isHidden =  false
        }
        else{
            self.nextButton.isHidden =  true
        }

    }
    
    
    
    public func position(position: Int, OfCurrentQuestionCell cell: UITableViewCell) {
        if position == numberOfQuestions - 1{
            self.nextButton.setTitle("Finish", for: UIControlState.normal)
        }
        else{
            self.nextButton.setTitle("Next", for: UIControlState.normal)
        }
        
        self.previousButton.isEnabled = position != 0
    }

    

    //MARK: - RegiterDataSource methods
    
    func numberOfQuestionsOn(RegisterTableView table: RegisterTableView) -> Int {
        return numberOfQuestions
    }
    
    func isQuestionOptional(position: Int) -> Bool {
        return false
    }
    
    func currentAnswerForQuestion(AtPosition position: Int) -> Any? {
        return answers[position]
    }
    
    func questionCellFor(RegisterTableView table: RegisterTableView, AtPosition position: Int) -> UITableViewCell! {
        
        let cell = table.dequeueReusableCell(withIdentifier: questionsOrder[position])!
        
        return cell
    }
}

