//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Georgy on 04.05.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testYesButton() throws{
        sleep(3)
        let firstPoster = app.images["Poster"] // Находим первый постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        app.buttons["Yes"].tap() //Находим кнопку "Да" и нажимаем на нее
        sleep(3)
        let secondPoster = app.images["Poster"] // Находим второй постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // Проверяем что постер изменился по нажатию кнопки
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testNoButton() throws{
        sleep(3)
        let firstPoster = app.images["Poster"] // Находим первый постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        app.buttons["No"].tap() //Находим кнопку "Да" и нажимаем на нее
        sleep(3)
        let secondPoster = app.images["Poster"] // Находим второй постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // Проверяем что постер изменился по нажатию кнопки
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testYesButtonIfPosterExist() throws{
        sleep(3)// Лишнее усложнение ожидания не требуется
        let firstPoster = app.images["Poster"] // Находим первый постер
        
        app.buttons["Yes"].tap() //Находим кнопку "Да" и нажимаем на нее
        sleep(3)
        let secondPoster = app.images["Poster"] // Находим второй постер
        
        XCTAssertTrue(firstPoster.exists) // проверка что первый постер существует
        
        XCTAssertTrue(secondPoster.exists) // проверка что второй постер существует
    }
    
    func testGameFinish() throws{
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game Results"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game Results"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    } 
}
