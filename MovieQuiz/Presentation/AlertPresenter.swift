//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Georgy on 11.04.2023.
//

import UIKit
final class AlertPresenter: AlertPresentorProtocol{

    weak var delegate: AlertPresentorDelegate?
    init(delegate: AlertPresentorDelegate) {
        self.delegate = delegate
    }
    
    func showAlert(on viewController: UIViewController, with model: AlertModel) {
            // попробуйте написать код создания и показа алерта с результатами
            let alert = UIAlertController(
                title: model.title,
                message: model.message,
                preferredStyle: .alert)
            
        let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
            guard let self = self else{
                return
            }
            self.delegate?.finishShowAlert()
            }
            
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
    }
    
    
}
