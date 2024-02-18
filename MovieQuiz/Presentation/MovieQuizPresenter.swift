//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Georgy on 08.05.2023.
//

import UIKit
final class MovieQuizPresenter{
    //MARK: - Init
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var statisticService:StatisticService?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    //MARK: - Variables
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    
    //MARK: - Quiz state methods
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        questionFactory?.requestNextQuestion()
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    //MARK: - Quiz lifecycle methods
     func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showNextQuestionOrResults() {
        if isLastQuestion(){ // 1
            // идём в состояние "Результат квиза"
            guard let statisticService = statisticService else {return}
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
    
    private func showAnswerResult(isCorrect: Bool) {
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else{return}
            viewController?.hideImageBorder()
            showNextQuestionOrResults()
        }
    }
    
    //MARK: - ButtonsClicked
    private func didAnswer(isYes:Bool){
        let answer = isYes
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = answer == currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
        correctAnswers += isCorrect ? 1:0
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
        
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter:QuestionFactoryDelegate{
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
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
}
