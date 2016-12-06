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
    
    override open func viewDidLoad() {

        super.viewDidLoad()
        setUpTableView()
        
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupTableVC(){
        
    }
    
    //MARK: - Register tableView Methods
    func currentQuestion()->RegisterQuestion{
        return self.tableView.visibleCells[0] as! RegisterQuestion
    }
    
    func sendAnswerOfQuestionAt(position: Int){
        let questionCell = self.tableView.visibleCells[0] as! RegisterQuestion
        self.answer(answer: questionCell.answer(), ForQuestionAtPosition: position)
    }
    
    func canGoToQuestion(AtPosition newPos:Int, fromPosition pos:Int)->Bool{
        let questionCell = self.tableView.visibleCells[0] as! RegisterQuestion
        if newPos >= pos{
            return newPos < self.tableView.numberOfRows(inSection: 0) && (self.isQuestionOptional(position: pos) || questionCell.isAValidAnswer())
        }
        return newPos >= 0
    }
    
    public func goToPreviousQuestion(){
        let pos = self.tableView.indexPathsForVisibleRows![0].row
        if canGoToQuestion(AtPosition: pos - 1, fromPosition: pos){
            sendAnswerOfQuestionAt(position: pos)
            self.tableView.scrollToRow(at: IndexPath(row: pos-1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    
    public func goToNextQuestion(){
        let pos = self.tableView.indexPathsForVisibleRows![0].row
        if canGoToQuestion(AtPosition: pos + 1, fromPosition: pos){
            sendAnswerOfQuestionAt(position: pos)
            self.tableView.scrollToRow(at: IndexPath(row: pos+1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    
    //MARK: - Gesture Recognizer delegate methods
    
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer{
            let yVelocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: self.view).y
            let pos = self.tableView.indexPathsForVisibleRows![0].row
            
            if canGoToQuestion(AtPosition: pos - Int(yVelocity)/abs(Int(yVelocity)), fromPosition: pos){
                sendAnswerOfQuestionAt(position: pos)
                return true
            }
            else{
                return false
            }
        }
        return true
    }
    
    
    
    
    //MARK: - TableView Methods
    
    private func setUpTableView(){
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //addSwipeGestures()
    }
    /*
    fileprivate func addSwipeGestures(){
        let swipeUpGes = UISwipeGestureRecognizer(target: self, action: "swipeAction")
        swipeUpGes.direction = UISwipeGestureRecognizerDirection.up
        self.tableView.addGestureRecognizer(swipeUpGes)
        
        let swipeDownGes = UISwipeGestureRecognizer(target: self, action: "swipeAction")
        swipeDownGes.direction = UISwipeGestureRecognizerDirection.down
        self.tableView.addGestureRecognizer(swipeDownGes)
    }
    
    func swipeAction(ges:UISwipeGestureRecognizer){
        let pos = self.tableView.indexPathsForVisibleRows![0].row
        switch ges.direction {
        case UISwipeGestureRecognizerDirection.down:
            if canGoToQuestion(AtPosition: pos - 1, fromPosition: pos){
                goToPreviousQuestion()
            }
            break
            //previus question
        case UISwipeGestureRecognizerDirection.up:
            if canGoToQuestion(AtPosition: pos + 1, fromPosition: pos){
                goToNextQuestion()
            }
            break
            //next question
        default:
            return
        }
    }
    */
    //MARK: - RegisterDelegate methods
    
    open func answer(answer: Any?, ForQuestionAtPosition position: Int) {
        assertionFailure("You must implement the answer method")
    }
    
    open func height(ForQuestionAtPosition position: Int) -> CGFloat {
        return self.view.frame.height
    }
    
    //MARK: - RegiterDataSource methods
    
    open func numberOfQuestionsOn(RegisterTableView table: RegisterTableView) -> Int {
        return 0
    }
    
    open func isQuestionOptional(position: Int) -> Bool {
        return true
    }

    //MARK: - TableView Delegate
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height(ForQuestionAtPosition: indexPath.row)
    }

    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let question = cell as? RegisterQuestion{
            question.activeQuestion()
        }
    }
    
    //MARK: TableViewDataSource
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @available(iOS 2.0, *)
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfQuestionsOn(RegisterTableView: tableView as! RegisterTableView)
    }
}
