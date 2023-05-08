//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Georgy on 08.05.2023.
//

import UIKit
final class MovieQuizPresenter{
    //MARK: - Variables
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion?
    let questionsAmount: Int = 10
    
    weak var viewController:MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    //MARK: - Methods
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
     func yesButtonClicked() {
        let answer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    func noButtonClicked() {
        let answer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        
    }
}
