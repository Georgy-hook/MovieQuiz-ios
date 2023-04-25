//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Georgy on 10.04.2023.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
