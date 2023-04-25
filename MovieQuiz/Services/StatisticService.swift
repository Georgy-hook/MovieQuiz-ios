//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Georgy on 14.04.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Accuracy { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    func formateToString() -> String{
        return "\(self.correct)/\(self.total) (\(self.date.dateTimeString))"
    }
}
struct Accuracy: Codable{
    var totalCorrect: Int //Общее число правильных ответов за все время работы приложения
    var totalQuestions: Int // Общее число вопросов заданных пользователю
    
    func get() -> String{
        let correct = Double(self.totalCorrect)
        let questions = Double(self.totalQuestions)
        let totalAccuracy = (correct/questions)*100
        return  "\(String(format: "%.2f",totalAccuracy))%"
    }
}
final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case totalAccuracy, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Accuracy{
        get{
            guard let data = userDefaults.data(forKey: Keys.totalAccuracy.rawValue),
            let record = try? JSONDecoder().decode(Accuracy.self, from: data) else {
                return .init(totalCorrect: 0, totalQuestions: 0)
            }
            
            return record
        }
        set{
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    var gamesCount: Int{
        get{
            let gameCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return gameCount
        }
        set{
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        totalAccuracy.totalCorrect += count
        totalAccuracy.totalQuestions += amount
        gamesCount = gamesCount + 1
        if count >= bestGame.correct {
            bestGame = GameRecord(correct: count, total:amount , date: Date())
        }
    }

}
