//
//  RegisterTableView.swift
//  Pods
//
//  Created by Nucleus on 05/12/16.
//
//

import UIKit

public protocol RegisterQuestion{
    func answer()->Any?
    func isAValidAnswer()->Bool
    func activeQuestion()
}


@objc public protocol RegisterDelegate{
    
    func answer(answer:Any?,ForQuestionAtPosition position:Int)
 
    @objc optional func height(ForQuestionAtPosition position:Int)->CGFloat

}



@objc public protocol RegisterDataSource{
    
    func numberOfQuestionsOn(RegisterTableView table:RegisterTableView)->Int
    
    func isQuestionOptional(position:Int)->Bool
    
    @objc optional func questionCellFor(RegisterTableView table:RegisterTableView,AtPosition position:Int)->UITableViewCell!
}


public class RegisterTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
        
    public var regDelegate:RegisterDelegate?{
        didSet{
            //self.delegate = self
        }
    }
    
    public var regDataSource:RegisterDataSource?{
        didSet{
            //self.dataSource = self
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTableView()

    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setUpTableView()
    }
    
    //MARK: - Register tableView Methods
    func currentQuestion()->RegisterQuestion{
        return self.visibleCells[0] as! RegisterQuestion
    }
    
    func sendAnswerOfQuestionAt(position: Int){
        let questionCell = self.visibleCells[0] as! RegisterQuestion
        self.regDelegate!.answer(answer: questionCell.answer(), ForQuestionAtPosition: position)
    }
    
    func canGoToQuestion(AtPosition newPos:Int, fromPosition pos:Int)->Bool{
        let questionCell = self.visibleCells[0] as! RegisterQuestion
        if newPos >= pos{
            return newPos < self.numberOfRows(inSection: 0) && (self.regDataSource!.isQuestionOptional(position: pos) || questionCell.isAValidAnswer())
        }
        return newPos >= 0
    }
    
    public func goToPreviousQuestion(){
        let pos = self.indexPathsForVisibleRows![0].row
        if canGoToQuestion(AtPosition: pos - 1, fromPosition: pos){
            sendAnswerOfQuestionAt(position: pos)
            self.scrollToRow(at: IndexPath(row: pos-1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }

    
    public func goToNextQuestion(){
        let pos = self.indexPathsForVisibleRows![0].row
        if canGoToQuestion(AtPosition: pos + 1, fromPosition: pos){
            sendAnswerOfQuestionAt(position: pos)
            self.scrollToRow(at: IndexPath(row: pos+1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    //MARK: - Gesture Recognizer delegate methods
    
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer{
            let yVelocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: self).y
            let pos = self.indexPathsForVisibleRows![0].row
            
            if canGoToQuestion(AtPosition: pos - Int(yVelocity)/abs(Int(yVelocity)), fromPosition: pos){
                sendAnswerOfQuestionAt(position: pos)
                return true
            }
            else{
                return false
            }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    //MARK: - TableView Methods
    
    private func setUpTableView(){
        self.isPagingEnabled = true
        self.allowsSelection = false
        self.showsVerticalScrollIndicator = false
    }
    
    
    //MARK: - TableView Delegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = regDelegate!.height{
            return height(indexPath.row)
        }
        return self.frame.height
    }
    
   
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let question = cell as? RegisterQuestion{
            question.activeQuestion()
        }
    }
    
    //MARK: TableViewDataSource
    
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regDataSource!.numberOfQuestionsOn(RegisterTableView: tableView as! RegisterTableView)
    }
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = regDataSource!.questionCellFor!(RegisterTableView: tableView as! RegisterTableView, AtPosition: indexPath.row)
        return cell!

    }
}