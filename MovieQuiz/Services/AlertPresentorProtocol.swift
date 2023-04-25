//
//  AlertPresentorProtocol.swift
//  MovieQuiz
//
//  Created by Georgy on 11.04.2023.
//

import UIKit
protocol AlertPresentorProtocol {
    func showAlert(on viewController: UIViewController, with model: AlertModel)
}
