import UIKit
final class MovieQuizViewController: UIViewController,AlertPresentorDelegate,MovieQuizViewControllerProtocol {
    //MARK: - Outlets
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    private var presenter: MovieQuizPresenter?
    private var alertPresentor: AlertPresentorProtocol?
    
    //MARK: - View customization
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - ImageBorder
    func highlightImageBorder(isCorrectAnswer: Bool){
        view.isUserInteractionEnabled = false
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor:UIColor.ypRed.cgColor //цвет рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
    }
    func hideImageBorder(){
        self.imageView.layer.borderWidth = 0 // толщина рамки
        view.isUserInteractionEnabled = true
    }
    
    // MARK: - Show question
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresentor = AlertPresenter(delegate: self)
        
    }
    
    // MARK: - Alert
    func showAlert(with resultModel: AlertModel) {
        alertPresentor?.showAlert(on: self, with: resultModel)
    }
    
    func showNetworkError(message: String) {
        let errorAlert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз")
        alertPresentor?.showAlert(on: self, with: errorAlert)
        activityIndicator.isHidden = true // скрываем индикатор загрузки
    }
    
    // MARK: - AlertPresentorDelegate
    func finishShowAlert() {
        presenter?.restartGame()
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // presenter.currentQuestion = currentQuestion
        presenter?.noButtonClicked()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        //presenter.currentQuestion = currentQuestion
        presenter?.yesButtonClicked()
    }
    
    // MARK: - Activity indicator
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
    }
    
}
