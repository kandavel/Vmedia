//
//  VmediaTests.swift
//  VmediaTests
//
//  Created by kandavel on 17/03/23.
//

import XCTest
@testable import Vmedia

class VmediaTests: XCTestCase {
    var view :  MockViewController!
    var presenterInput  : ChannelListPresentorProtocol!
    var presentproutput : ChannelListInteractorOutputProtocol!
    var interactor : ChannelListInteractorProtocol!
    
    
    override func setUp() {
        super.setUp()
        self.view = MockViewController()
        self.interactor  = ChannelListViewInteractor()
        let input  = ChannelListPresentor()
        input.view  = self.view
        input.interactor  = self.interactor
        self.presenterInput = input
        self.presentproutput =  input
        self.view.presenter  =  self.presenterInput
        
    }

    override func tearDown() {
        presenterInput = nil
        presentproutput = nil
        interactor = nil
        view = nil
    }

    func test_viewDidLoad() {
        XCTAssertFalse(view.isInvokedShowLoadingView, "Your value is true, but you expected it to be false")
        XCTAssertFalse(view.isInvokedHideLoadingView, "Your value is true, but you expected it to be false")
        XCTAssertFalse(view.isInvokedSetTitle, "Your value is true, but you expected it to be false")
        XCTAssertFalse(view.isInvokedSetupSpreadsheetView, "Your value is true, but you expected it to be false")
        presenterInput.viewDidLoad()
        XCTAssertTrue(view.isInvokedSetTitle, "Your value is false, but you expected it to be true")
        XCTAssertTrue(view.isInvokedShowLoadingView, "Your value is false, but you expected it to be true")
        XCTAssertTrue(view.isInvokedSetupSpreadsheetView, "Your value is false, but you expected it to be true")
    }
    
    func test_PresentorIntialState() {
        XCTAssertNil(presenterInput.getChannelInfo(indexPath: IndexPath(row: 0, column: 0)), "Expected Nil")
        XCTAssertEqual(presenterInput.getTitle(), "VMedia")
        XCTAssertEqual(presenterInput.numberOfColumnCount(), 0)
        XCTAssertEqual(presenterInput.numberOfRowsCount(), 0)
    }
    
    func test_InvokeAPIData() {
        (presenterInput as? ChannelListPresentor)?.setChannelListData()
        presentproutput.didFetchChannelListData(result: .success(ChannelListResponse.channelListresponse))
        presentproutput.didFetchChannelProgramListData(result: .success(ChannelListResponse.programListresponse))
        XCTAssertTrue(presenterInput.numberOfColumnCount() > 0)
        XCTAssertTrue(presenterInput.numberOfRowsCount() > 0)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockViewController: HomeViewProtocol {
    var presenter: ChannelListPresentorProtocol?
    var isInvokedReloadData = false
    var isInvokedShowLoadingView = false
    var isInvokedHideLoadingView = false
    var isInvokedSetTitle = false
    var isInvokedSetupSpreadsheetView = false
    var isInvokedSetupUI = false
    
    
    func reloadData() {
        isInvokedReloadData = true
    }
    
    func registerCollectionView() {
        isInvokedSetupUI = true
    }
    
    func showLoadingView() {
        isInvokedShowLoadingView = true
    }
    
    func hideLoadingView() {
        isInvokedHideLoadingView = true
    }
    
    func hideView() {
        isInvokedHideLoadingView = true
    }
    
    func registerNib() {
        isInvokedSetupSpreadsheetView = true
    }
    
    func showTitle() {
        isInvokedSetTitle = true
    }
    
}

extension ChannelListResponse {
    static var channelListresponse: [Channel] {
        let bundle = Bundle(for: VmediaTests.self)
        let path = bundle.path(forResource: "ChannelList", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)!
        let movieResponse = try! JSONDecoder().decode([Channel].self, from: data)
        return movieResponse
    }
    
    static var programListresponse: [ChannelProgram] {
        let bundle = Bundle(for: VmediaTests.self)
        let path = bundle.path(forResource: "ProgramList", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)!
        let movieResponse = try! JSONDecoder().decode([ChannelProgram].self, from: data)
        return movieResponse
    }
}


