//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Georgy on 09.04.2023.
// вью модель для состояния "Вопрос показан"

import Foundation
import UIKit
struct QuizStepViewModel {
    // картинка с афишей фильма с типом UIImage
    let image: UIImage
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}
