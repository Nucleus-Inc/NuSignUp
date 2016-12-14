//
//  RegisterTableView.swift
//  Pods
//
//  Created by Nucleus on 05/12/16.
//
//

import UIKit

public protocol RegisterQuestion{
    /**
     Do not assign a value to this property just use the methods of this protocol to send constant updates to user about the state of your answer, more details take a look on example project
     */
    var answerListener:AnswerListener!{get set}
    
    func setAnswer(answer:Any)
    func answer()->Any?
    func isAValidAnswer()->Bool
    func activeQuestion()
    func desactiveQuestion()
    
}

/**
 This is  protocol that helps for constant knowledge about answer state
 */
public protocol AnswerListener{
    
    func changeAnswer(answer:Any?, ToStateValid valid:Bool)
    
}


@objc public protocol RegisterDelegate{
    
    func answer(answer:Any?,Isvalid valid:Bool,ForQuestionCellAtPosition position:Int)
    
    func position(position:Int, OfCurrentQuestionCell cell:UITableViewCell)
    
    @objc optional func height(ForQuestionCellAtPosition position:Int)->CGFloat

}



@objc public protocol RegisterDataSource{
    
    func numberOfQuestionsOn(RegisterTableView table:RegisterTableView)->Int
    
    func isQuestionOptional(position:Int)->Bool
    
    func currentAnswerForQuestion(AtPosition position:Int)->Any?
    
    @objc optional func questionCellFor(RegisterTableView table:RegisterTableView,AtPosition position:Int)->UITableViewCell!
}

public class RegisterTableView: UITableView,UITableViewDelegate,UITableViewDataSource,AnswerListener {
   
    
    
    var nextQuestionButton:RegisterButton!
    
    public var regDelegate:RegisterDelegate!{
        didSet{
            guard let _ = self.delegate else{
                self.delegate = self
                return
            }
        }
    }
    
    public var regDataSource:RegisterDataSource!{
        didSet{
            guard let _ = self.dataSource else{
                self.dataSource = self
                return
            }
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
    public func currentQuestion()->RegisterQuestion{
        return self.visibleCells[0] as! RegisterQuestion
    }
    
    public func currentQuestionCell()->UITableViewCell{
        return self.visibleCells[0]
    }
    
    public func currentQuestionPosition()->Int{
        return self.indexPathsForVisibleRows![0].row
    }
    
    func sendAnswerOfQuestionAt(position: Int){
        
        let questionCell = self.cellForRow(at: IndexPath(row: position, section: 0)) as! RegisterQuestion
        self.regDelegate.answer(answer: questionCell.answer(), Isvalid: questionCell.isAValidAnswer(), ForQuestionCellAtPosition: position)
        
    }
    
    
    private func activeQuestionAt(position:Int){
        let cell = self.cellForRow(at: IndexPath(row: position, section: 0))
        let questionCell = cell as! RegisterQuestion
        questionCell.activeQuestion()
        regDelegate.position(position: position, OfCurrentQuestionCell: cell!)
    }
   
    private func desactiveQuestionAt(position:Int){
        let questionCell = self.cellForRow(at: IndexPath(row: position, section: 0)) as! RegisterQuestion
        questionCell.desactiveQuestion()
    }
    
    func canGoToQuestion(AtPosition newPos:Int, fromPosition pos:Int)->Bool{
        let questionCell = self.cellForRow(at: IndexPath(row: pos, section: 0)) as! RegisterQuestion
        if newPos >= pos{
            return newPos < self.numberOfRows(inSection: 0) && (self.regDataSource.isQuestionOptional(position: pos) || questionCell.isAValidAnswer())
        }
        return newPos >= 0
    }
    
    /**
     Call this method for you return to a previous question
     */
    public func goToPreviousQuestion(){
        let pos = self.indexPathsForVisibleRows![0].row
        if canGoToQuestion(AtPosition: pos - 1, fromPosition: pos){
            sendAnswerOfQuestionAt(position: pos)
            
            DispatchQueue.main.async {
                self.desactiveQuestionAt(position: pos)
            }
            self.scrollToRow(at: IndexPath(row: pos-1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }

    /**
     Call this method for you go to the next question if possible.
     */
    public func goToNextQuestion(){
        
        let pos = self.indexPathsForVisibleRows![0].row
        if canGoToQuestion(AtPosition: pos + 1, fromPosition: pos){
            sendAnswerOfQuestionAt(position: pos)
            
            DispatchQueue.main.async {
                self.desactiveQuestionAt(position: pos)
            }
            
            
            self.scrollToRow(at: IndexPath(row: pos+1, section: 0), at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    //MARK: - Gesture Recognizer delegate methods
    
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer{
            let yVelocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: self).y
            let pos = self.indexPathsForVisibleRows![0].row
            
            if yVelocity != 0{
                if canGoToQuestion(AtPosition: pos - Int(yVelocity)/abs(Int(yVelocity)), fromPosition: pos){
                    DispatchQueue.main.async {
                        self.desactiveQuestionAt(position: pos)
                    }
                    sendAnswerOfQuestionAt(position: pos)
                    return true
                }
                else{
                    return false
                }

            }
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    //MARK: - Answer Listener methods
    
    public func changeAnswer(answer: Any?, ToStateValid valid: Bool) {
        let position = self.currentQuestionPosition()
        self.regDelegate!.answer(answer: answer, Isvalid: valid, ForQuestionCellAtPosition: position)
    }

    
    
    //MARK: - TableView Methods
    
    private func setUpTableView(){
        self.isPagingEnabled = true
        //self.isScrollEnabled = false
        self.allowsSelection = false
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    
    //MARK: TableView Delegate
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = regDelegate.height{
            return height(indexPath.row)
        }
        return self.frame.height
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = regDelegate.height{
            return height(indexPath.row)
        }
        return self.frame.height
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("foi")
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let question = cell as? RegisterQuestion{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                question.activeQuestion()
            }
            self.regDelegate.position(position: indexPath.row, OfCurrentQuestionCell: cell)
        }
    }
    
    //MARK: TableView DataSource
    
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regDataSource.numberOfQuestionsOn(RegisterTableView: tableView as! RegisterTableView)
    }
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = regDataSource.questionCellFor!(RegisterTableView: tableView as! RegisterTableView, AtPosition: indexPath.row)
        
        
        if var questionCell = cell as? RegisterQuestion{
            questionCell.answerListener = self
            questionCell.setAnswer(answer: self.regDataSource.currentAnswerForQuestion(AtPosition: indexPath.row))
        }
        else{
            assertionFailure("Your cell must implement RegisterQuestion protocol")
        }
        
        return cell!
    }
}


public extension UILabel{
    public func emphasyzeText(text:String,color:UIColor,font:UIFont){
        let attibutedText = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName:self.font])
        
        let string = NSString(string: self.text!)
        let range = string.range(of: text)
        
        attibutedText.addAttribute(NSFontAttributeName, value: font, range: range)
        attibutedText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)

        
    }
    
    public func emphasyzeText(text:String,attributedStringAttributes:[String:Any]){
        let attibutedText = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName:self.font])
        let string = NSString(string: self.text!)
        let range = string.range(of: text)
        for key in attributedStringAttributes.arrayOfKeys(){
            if let value = attributedStringAttributes[key]{
                attibutedText.addAttribute(key, value: value, range: range)
            }
        }
    }
}


public extension Dictionary{
    func arrayOfKeys()-> [Key]{
        return self.flatMap { (_ tupla: (key: Key, value: Value)) -> Key? in
            return tupla.key
        }
    }
}

