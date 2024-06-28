//
//  Flow.swift
//  EssDevQuizEngine
//
//  Created by admin on 25.06.2024.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping (String) -> Void)
    func routeTo(results: [String : String])
}

final class Flow {
    private let router: Router
    private let questions: [String]
    private var results: [String : String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nexxtCallback(question: firstQuestion))
        } else {
            router.routeTo(results: results)
        }
    }
    
    private func nexxtCallback(question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            self?.route(question: question, answer: answer)
        }
    }
    private func route(question: String, answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            results[question] = answer
            let nextQuestionindex = currentQuestionIndex + 1
            if nextQuestionindex < questions.count {
                let nextQuestion = questions[nextQuestionindex]
                router.routeTo(question: nextQuestion, answerCallback: nexxtCallback(question:nextQuestion))
            } else {
                router.routeTo(results: results)
            }
        }
    }
}
