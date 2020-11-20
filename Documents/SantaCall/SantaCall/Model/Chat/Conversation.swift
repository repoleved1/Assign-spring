import Foundation

class Conversation {
    // List of Messages in the conversation
    var messages = [Message]()
    
    // Add welcoming text to open the conversation
    init() {
        messages.append(Message(date: Date(), text: "Hohoho!!\nHi child, how are you?", type: .answer))
    }
    // Add a new question to the conversation
    func add(question: String) {
        messages.append(Message(date: Date(), text: question, type: .question))
    }
    
    // Add a new answer to the conversation
    func add(answer: String) {
        messages.append(Message(date: Date(), text: answer, type: .answer))
    }
}
