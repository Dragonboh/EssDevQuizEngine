//
//  Flow.swift
//  EssDevQuizEngine
//
//  Created by admin on 25.06.2024.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallback: @escaping (String) -> Void)
}

final class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion) { [weak self] _ in
                guard let self = self else { return }
                let firstQuestionIndex = questions.firstIndex(of: firstQuestion)!
                let nextQuestion = questions[firstQuestionIndex + 1]
                router.routeTo(question: nextQuestion) { _ in
                    
                }
            }
        }
    }
}
