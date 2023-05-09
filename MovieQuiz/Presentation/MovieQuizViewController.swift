import UIKit

final class MovieQuizViewController: UIViewController,AlertPresentorDelegate, QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    //MARK: - Outlets
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresentor: AlertPresentorProtocol?
    let statisticService:StatisticService = StatisticServiceImplementation()
    
    //MARK: - View customization
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private functions
    // берём текущий вопрос из массива вопросов по индексу текущего вопроса
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
     func showAnswerResult(isCorrect: Bool) {
        view.isUserInteractionEnabled = false
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor:UIColor.ypRed.cgColor // делаем рамку белой
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
         presenter.correctAnswers += isCorrect ? 1:0
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else{return}
            self.imageView.layer.borderWidth = 0 // толщина рамки
            // код, который мы хотим вызвать через 1 секунду
            presenter.showNextQuestionOrResults()
            view.isUserInteractionEnabled = true
        }
    }
    
   
 
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
     func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        // попробуйте написать код показа на экран самостоятельно
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
     func showAlert(with resultModel: AlertModel) {
            alertPresentor?.showAlert(on: self, with: resultModel)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        self.presenter.questionFactory = questionFactory
        questionFactory?.loadData()
        showLoadingIndicator()
        alertPresentor = AlertPresenter(delegate: self)
        
    }
    
    // MARK: - QuestionFactoryDelegate
   
    
    // MARK: - AlertPresentorDelegate
    func finishShowAlert() {
        presenter.resetQuestionIndex()
        // сбрасываем переменную с количеством правильных ответов
        //self.correctAnswers = 0
        // заново показываем первый вопрос
        self.questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Actions
    @IBAction func noButtonClicked(_ sender: UIButton) {
       // presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
        
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        //presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    // MARK: - Activity indicator
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // MARK: - Load Data
     func showNetworkError(message: String) {
        let errorAlert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз")
        alertPresentor?.showAlert(on: self, with: errorAlert)
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        
        // создайте и покажите алерт
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
}
