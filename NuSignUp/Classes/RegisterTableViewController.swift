//
//  RegisterTableViewController.swift
//  Pods
//
//  Created by Nucleus on 06/12/16.
//
//

import UIKit



/**
 Use this class if you pretend to use static cells, if not use RegisterTableView instead
 */
open class RegisterTableViewController: UITableViewController,RegisterDelegate,RegisterDataSource {
    
    
    public var registerTableView:RegisterTableView!{
        get{
            return self.tableView as! RegisterTableView
        }
    }
    
    override open func viewDidLoad() {

        super.viewDidLoad()
        setupTableVC()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupTableVC(){
        setUpRegisterTableView()
    }
    
    //MARK: - TableView protocols Methods
    
    private func setUpRegisterTableView(){
        registerTableView.regDelegate = self
        registerTableView.regDataSource = self
    }
    //MARK: RegisterDelegate methods
    
    open func answer(answer: Any?, ForQuestionCellAtPosition position: Int) {
        assertionFailure("You must implement the answer method")
    }
    
    open func height(ForQuestionCellAtPosition position: Int) -> CGFloat {
        return self.view.frame.height
    }
    
    //MARK: RegiterDataSource methods
    
    open func numberOfQuestionsOn(RegisterTableView table: RegisterTableView) -> Int {
        return 0
    }
    
    open func isQuestionOptional(position: Int) -> Bool {
        return true
    }
    //MARK:  TableView Delegate
    
    open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height(ForQuestionCellAtPosition: indexPath.row)
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height(ForQuestionCellAtPosition: indexPath.row)
    }

    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let question = cell as? RegisterQuestion{
            //question.activeQuestion()

            /*let position = indexPath.row
            if position > 0{
                let previousQuestion = tableView.cellForRow(at: IndexPath(row: position - 1, section: indexPath.section)) as! RegisterQuestion
                if previousQuestion.isAValidAnswer(){
                    //question.activeQuestion()
                }
            }
            else{
                //question.activeQuestion()
            }*/
        }
    }
    
    
    //MARK: TableViewDataSource
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @available(iOS 2.0, *)
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfQuestionsOn(RegisterTableView: registerTableView)
    }
}
