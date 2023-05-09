//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Georgy on 08.05.2023.
//

import UIKit
final class MovieQuizPresenter:QuestionFactoryDelegate{
    func didLoadDataFromServer() {
        print("error")
    }
    
    func didFailToLoadData(with error: Error) {
        print("error")
    }
    
    //MARK: - Variables
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion?
    let questionsAmount: Int = 10
    let statisticService:StatisticService = StatisticServiceImplementation()
     var questionFactory: QuestionFactoryProtocol?
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
     var correctAnswers = 0
    
    weak var viewController:MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
        correctAnswers = 0
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
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{
                return
            }
            self.viewController?.show(quiz: viewModel)
        }
    }
    
     func showNextQuestionOrResults() {
        if isLastQuestion(){ // 1
            // идём в состояние "Результат квиза"
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let resultModel = AlertModel(title: "Этот раунд окончен!",
                                         message: """
                                                Ваш результат: \(correctAnswers)/\(questionsAmount)\n
                                                Количество сыграных квизов: \(statisticService.gamesCount)\n
                                                Рекорд:\(statisticService.bestGame.formatToString())\n
                                                Средняя точность:\(statisticService.totalAccuracy.formatToString())
                                                """,
                                         buttonText: "Сыграть ещё раз")
            viewController?.showAlert(with: resultModel)
        } else { // 2
            switchToNextQuestion()
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
            
        }
    }
    //MARK: - ButtonsClicked
    private func didAnswer(isYes:Bool){
        let answer = isYes
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
        
    }
    
    
}
