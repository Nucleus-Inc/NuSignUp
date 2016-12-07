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
    
    let numberOfQuestions:Int = 5
    
    //var questions:[String]!
    var answers:[Any] = [Any?](repeating: nil, count: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableV.regDataSource = self
        registerTableV.regDelegate = self
        
        
// Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - RegisterDelegate methods
    
    func answer(answer: Any?, ForQuestionCellAtPosition position: Int) {
        print(answer as! String)
        answers[position] = answer!
    }
    
    

    //MARK: - RegiterDataSource methods
    
    func numberOfQuestionsOn(RegisterTableView table: RegisterTableView) -> Int {
        return numberOfQuestions
    }
    
    func isQuestionOptional(position: Int) -> Bool {
        return false
    }
    
    func questionCellFor(RegisterTableView table: RegisterTableView, AtPosition position: Int) -> UITableViewCell! {
        
        let cell = table.dequeueReusableCell(withIdentifier: "simpleQuestion") as! BasicQuestionCell
        
        cell.questionLabel.text = "Digite o seu nome \(position)"
        
        cell.setAnswer(answer: answers[position])
        
        return cell
    }
}

