//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Georgy on 09.04.2023.
//

import Foundation
final class QuestionFactory:QuestionFactoryProtocol {
    // массив вопросов
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        MoviesLoader().loadMovies{[weak self] result in
            guard let self = self else{
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result{
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    //    private let questions: [QuizQuestion] = [
    //        QuizQuestion(image: "The Godfather",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "The Dark Knight",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "Kill Bill",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "The Avengers",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "Deadpool",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "The Green Knight",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "Old",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: false),
    //        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: false),
    //        QuizQuestion(image: "Tesla",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: false),
    //        QuizQuestion(image: "Vivarium",
    //                     text: "Рейтинг этого фильма больше чем 6?",
    //                     correctAnswer: false)
    //    ]
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            //Выбираем произвольный элемент массива для отображения
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            // Загрузка данных
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0 //Превращаем строку в число
            
            let value = Int.random(in: 1...10)
            let text = "Рейтинг этого фильма больше чем \(value)?"
            let correctAnswer = rating > Float(value)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
