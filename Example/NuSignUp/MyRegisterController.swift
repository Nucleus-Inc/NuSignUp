//
//  MyRegisterController.swift
//  NuLikeSignUp
//
//  Created by Nucleus on 06/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp

class MyRegisterController: RegisterTableViewController {

    var answers:[Any] = [Any?](repeating: nil, count: 3)

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - RegisterDelegate methods
    
    override func answer(answer: Any?, ForQuestionAtPosition position: Int) {
        print(answer as! String)
        answers[position] = answer!
    }
    
    //MARK: - RegiterDataSource methods
    
    override func numberOfQuestionsOn(RegisterTableView table: RegisterTableView) -> Int {
        return 1
    }
    
    override func isQuestionOptional(position: Int) -> Bool {
        return false
    }



}
