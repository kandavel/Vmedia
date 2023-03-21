
# VMedia

Test Task for Apple Developer Candidate

Page 1: Development Plan
         
            the VIPER modules

            View
            Interactor
            Presenter
            Entity
            Router 



   -> Here is a high-level overview of each step:




## Here is a high-level overview of each step
    
### View: Displays the table view with the segregated dates, and communicates user interactions to the Presenter.

### Interactor: Handles business logic, such as fetching the dates and segregating them into 30-minute intervals.

### Presenter: Processes events from the View and the Interactor, preparing the data for display, and updating the View.

### Entity: Represents the Date object used throughout the application.
### Router: Manages navigation between screens.
## SampleCode

import Foundation

protocol ChannelListPresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol ChannelListInteractorProtocol: AnyObject {
    func fetchDates(completion: @escaping (Result<[Date], Error>) -> Void)
}

class ChannelListListPresenter: ChannelListPresenterProtocol {
    weak var view: ChannelListViewProtocol?
    var interactor: ChannelListInteractorProtocol
    var router: ChannelListRouterProtocol

    init(view: ChannelListViewProtocol, interactor: ChannelListInteractorProtocol, router: ChannelListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchDates { [weak self] result in
            switch result {
            case .success(let dates):
                let segregatedDates = segregateDatesByThirtyMinuteIntervals(dates: dates)
                DispatchQueue.main.async {
                    self?.view?.displayDates(segregatedDates)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.displayError(error.localizedDescription)
                }
            }
        }
    }
}

class ChannelListInteractor: ChannelListInteractorProtocol {
    func fetchDates(completion: @escaping (Result<[Date], Error>) -> Void) {
        // Call the API to fetch the dates and return the result via the completion handler.
    }
}

## Demo

Insert gif or link to demo


https://user-images.githubusercontent.com/16301500/226747863-28d0c1cb-c7d0-4735-8b97-0508290a63d5.mp4



