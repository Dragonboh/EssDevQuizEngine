//
//  Flow.swift
//  EssDevQuizEngine
//
//  Created by admin on 25.06.2024.
//

import Foundation

protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
//    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(results: [Question : Answer])
}

final class Flow<Question: Hashable, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    
    private let router: R
    private let questions: [Question]
    private var results: [Question : Answer] = [:]
    
    init(questions: [Question], router: R) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(question: firstQuestion))
        } else {
            router.routeTo(results: results)
        }
    }
    
    private func nextCallback(question: Question) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.route(question: question, answer: answer)
        }
    }
    private func route(question: Question, answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            results[question] = answer
            let nextQuestionindex = currentQuestionIndex + 1
            if nextQuestionindex < questions.count {
                let nextQuestion = questions[nextQuestionindex]
                router.routeTo(question: nextQuestion, answerCallback: nextCallback(question:nextQuestion))
            } else {
                router.routeTo(results: results)
            }
        }
    }
}
