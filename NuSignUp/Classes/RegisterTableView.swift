//
//  RegisterTableView.swift
//  Pods
//
//  Created by Nucleus on 05/12/16.
//
//

import UIKit

public protocol RegisterQuestion{
    func setAnswer(answer:Any)
    func answer()->Any?
    func isAValidAnswer()->Bool
    func activeQuestion()
    func desactiveQuestion()

}


@objc public protocol RegisterDelegate{
    
    func answer(answer:Any?,ForQuestionCellAtPosition position:Int)
    
    func position(position:Int, OfCurrentQuestionCell cell:UITableViewCell)
    
    @objc optional func height(ForQuestionCellAtPosition position:Int)->CGFloat

}



@objc public protocol RegisterDataSource{
    
    func numberOfQuestionsOn(RegisterTableView table:RegisterTableView)->Int
    
    func isQuestionOptional(position:Int)->Bool
    
    @objc optional func questionCellFor(RegisterTableView table:RegisterTableView,AtPosition position:Int)->UITableViewCell!
}

public class RegisterTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
   
    
    
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
    func currentQuestion()->RegisterQuestion{
        return self.visibleCells[0] as! RegisterQuestion
    }
    
    func currentQuestionPosition()->Int{
        return self.indexPathsForVisibleRows![0].row
    }
    
    func sendAnswerOfQuestionAt(position: Int){
        let questionCell = self.cellForRow(at: IndexPath(row: position, section: 0)) as! RegisterQuestion
        self.regDelegate.answer(answer: questionCell.answer(), ForQuestionCellAtPosition: position)
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
            self.scrollToRow(at: IndexPath(row: pos+1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
       
    //MARK: - TableView Methods
    
    private func setUpTableView(){
        self.isPagingEnabled = true
        self.isScrollEnabled = false
        self.allowsSelection = false
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    
    //MARK: TableView Delegate
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
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
        return cell!
    }
}


public extension UILabel{
    open func emphasyzeText(text:String,color:UIColor,font:UIFont){
        var attibutedText = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName:self.font])
        if let range = self.text!.range(of: text) as? NSRange{
            attibutedText.addAttribute(NSFontAttributeName, value: font, range: range)
            attibutedText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
        
    }
    
    open func emphasyzeText(text:String,attributedStringAttributes:[String:Any]){
        var attibutedText = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName:self.font])
        if let range = self.text!.range(of: text) as? NSRange{
            for key in attributedStringAttributes.arrayOfKeys(){
                attibutedText.addAttribute(key, value: attributedStringAttributes[key], range: range)
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

