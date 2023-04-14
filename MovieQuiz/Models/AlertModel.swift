//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Georgy on 11.04.2023.
//

import Foundation
struct AlertModel{
    //текст заголовка алерта
    let title:String
    //текст сообщения алерта
    let message:String
    //текст для кнопки алерта
    let buttonText:String
    //замыкание без параметров для действия по кнопке алерта
    func buttonAction (completion: @escaping () -> Void){
        
    }
}
