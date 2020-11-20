//
//  ChatViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/5/20.
//

import UIKit

class ChatViewController: BaseViewController {
    
    //MARK: -- Outlet
    @IBOutlet weak var viewNavi: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var heightContentMess: NSLayoutConstraint!
    
    //MARK: -- Variables
    let eliza = Eliza()
    let conversation = Conversation()
    var placeholderTextView : UILabel!
    var typeCall: TypeCall = .phone

    private let thinkingTime: TimeInterval = 1
    fileprivate var isThinking = false
    
    var timer: Timer?
    
    //MARK: -- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        configView()
        setupTableView()
        self.initializeHideKeyboard()
        tvContent.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        heightContentMess.constant = 45
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    func configView() {
        // View Layout
        viewNavi.clipsToBounds = true
        viewNavi.layer.cornerRadius = 20
        viewNavi.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        viewFooter.clipsToBounds = true
        viewFooter.layer.cornerRadius = 20
        viewFooter.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if IS_IPAD {
            tvContent.font = .applicationFontRegular(20)
        } 
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SantaClausMessCell.className, bundle: nil), forCellReuseIdentifier: SantaClausMessCell.className)
        tableView.register(UINib(nibName: MyMessCell.className, bundle: nil), forCellReuseIdentifier: MyMessCell.className)
        tableView.register(UINib(nibName: ClearTableViewCell.className, bundle: nil), forCellReuseIdentifier: ClearTableViewCell.className)

    }
    
    //MARK: -- Actions
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMess(_ sender: Any) {
        guard let text = tvContent.text else {
            return
        }
        
        // Deal with the question
        tvContent.text = nil
        respondToQuestion(text.trimmingCharacters(in: .newlines))
        tvContent.resignFirstResponder()
    }
    
    @IBAction func openCallingSantaVC(_ sender: Any) {
        let callingSantaVC = GetCallViewController()
        typeCall = .phone
        navigationController?.pushViewController(callingSantaVC, animated: true)
    }
    
    @IBAction func openCallingVideoVC(_ sender: Any) {
        let callingVideoVC = GetCallViewController()
        typeCall = .video
        callingVideoVC.typeCall = typeCall
        navigationController?.pushViewController(callingVideoVC, animated: true)
    }
    
    // Called when the user enters a question.
    fileprivate func respondToQuestion(_ questionText: String) {
        // A question can't be asked while the app is thinking.
        isThinking = true
        
        // Add a question and create an index path for a new cell at the end of the conversation
        conversation.add(question: questionText)
        let questionPath = IndexPath(row: conversation.messages.count - 1, section: ConversationSection.history.rawValue)
        
        // Inserts a row for the thinking cell, and for the newly added question (if that exists)
        tableView.insertRows(at: [questionPath, ConversationSection.thinkingPath].flatMap { $0 }, with: .bottom)
        tableView.scrollToRow(at: ConversationSection.askPath, at: .bottom, animated: true)
        
        // Waits for the thinking time to elapse before adding the answer
        DispatchQueue.main.asyncAfter(deadline: .now() + thinkingTime) {
            // It's now OK to ask another question
            self.isThinking = false
            // Get an answer from the question answerer
            let answer = self.eliza.replyTo(questionText)
            // As before, check that adding an answer actually increases the message count
            self.conversation.add(answer: answer)
            // Several updates are happening to the table so they are grouped inside begin / end updates calls
            self.tableView.beginUpdates()
            // Add the answer cell, if applicable
            self.tableView.insertRows(at: [IndexPath(row:self.conversation.messages.count - 1, section: ConversationSection.history.rawValue)], with: .fade)
            // Delete the thinking cell
            self.tableView.deleteRows(at: [ConversationSection.thinkingPath], with: .fade)
            self.tableView.endUpdates()
            // Make sure the ask cell is visible
            self.tableView.scrollToRow(at: ConversationSection.askPath, at: .bottom, animated: true)
        }
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate enum ConversationSection: Int {
        case history = 0  // Where the conversation goes
        case thinking = 1  // Where the thinking indicator goes
        case ask = 2  // Where the ask box goes
        
        static var sectionCount: Int {
            return self.ask.rawValue + 1
        }
        
        static var allSections: IndexSet {
            return IndexSet(integersIn: 0..<sectionCount)
        }
        
        static var askPath: IndexPath {
            return IndexPath(row: 0, section: self.ask.rawValue)
        }
        
        static var thinkingPath: IndexPath {
            return IndexPath(row: 0, section: self.thinking.rawValue)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ConversationSection.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ConversationSection(rawValue: section)! {
        case .history:
            // This is one of the questions the conversation data source is asked
            return conversation.messages.count
        case .thinking:
            // No cells if the app is not thinking, one cell if it is
            return isThinking ? 1 : 0
        case .ask:
            // Always one cell in the ask section
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ConversationSection(rawValue: indexPath.section)! {
        case .history:
            // Ask the conversation data source for the correct message
            let message = conversation.messages[indexPath.row]
            
            // Get the right identifier depending on the message type
            switch message.type {
            case .question:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: MyMessCell.className, for: indexPath) as? MyMessCell {
                    let message = conversation.messages[indexPath.row]
                    cell.setupCell(mess: message.text)
                    cell.backgroundColor = .clear
                    return cell
                }
                
            case .answer:
                if let cell = tableView.dequeueReusableCell(withIdentifier: SantaClausMessCell.className, for: indexPath) as? SantaClausMessCell {
                    if indexPath.row % 2 == 0 {
                        let message = conversation.messages[indexPath.row]
                        cell.setupCell(content: message.text)
                    }
                    cell.backgroundColor = .clear
                    return cell
                }
            }
        // Get a cell of the correct design from the storyboard
        
        case .thinking:
            let cell = tableView.dequeueReusableCell(withIdentifier: ClearTableViewCell.className, for: indexPath) as? ClearTableViewCell
            return cell!
        case .ask:
            // The ask cell is always the same. The text field delegate has to be set so that you know when the user has asked a question
//            let cell = tableView.dequeueReusableCell(withIdentifier: ClearTableViewCell.className, for: indexPath) as? ClearTableViewCell
//            return cell!
            ()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: Table view delegate
extension ChatViewController {
    // This is a guess for the height of each row
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch ConversationSection(rawValue: indexPath.section)! {
        case .ask:
            return 0
        case .history:
            return 60
        case .thinking:
            return 20

        }
    }
    // This tells the table to make the row the correct height based on the contents
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch ConversationSection(rawValue: indexPath.section)! {
        case .ask:
            return 0
        case .history:
            return UITableView.automaticDimension
        case .thinking:
            return 20

        }
//        return UITableView.automaticDimension
    }
}

//MARK: -- UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    
    func setupCommentPostView() {
        tvContent.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("did begin edit")
        heightContentMess.constant = 80
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("did end edit")
        heightContentMess.constant = 40
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        if tvContent.text.isEmpty {
//            tvContent.text = "Type your message"
//            tvContent.textColor = UIColor.lightGray
//        }
        
        
        print("did change")

    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}
