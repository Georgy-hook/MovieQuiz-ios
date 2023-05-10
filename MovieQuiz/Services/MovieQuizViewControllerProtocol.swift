//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Georgy on 10.05.2023.
//

import Foundation
protocol MovieQuizViewControllerProtocol: AnyObject{
    func highlightImageBorder(isCorrectAnswer: Bool)
    func hideImageBorder()
    
    func show(quiz step: QuizStepViewModel)
    
    func showAlert(with resultModel: AlertModel)
    func showNetworkError(message: String)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
