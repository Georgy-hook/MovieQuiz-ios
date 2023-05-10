//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Georgy on 10.05.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol{
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func hideImageBorder() {
        
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func showAlert(with resultModel: MovieQuiz.AlertModel) {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
}

final class MovieQuizPresenterTests:XCTestCase{
    func testPresenterConvertModel() throws{
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
