//
//  HomeViewModelTests.swift
//  Survey2024Tests
//
//  Created by Thy Nguyen on 8/24/24.
//

import XCTest
import Nimble
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Survey2024

final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!
    private let container = MockDependencyContainer()
    
    func testLoadFirstPageSuccessFully() {
        // given
        stub(condition: isPath("/api/v1/surveys")) { _ in
            let path: String! = OHPathForFile("default_survey_list_page_1.json", type(of: self))
            return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
        }
        sut = container.resolve(HomeViewModel.self)
        
        // when
        sut.trigger.send(())
        
        // then
        expect(self.sut.dataSource.count).toEventually(equal(3))
        expect(self.sut.errorMessage).toEventually(beNil())
        expect(self.sut.showAlert).toEventually(beFalse())
    }
    
    func testLoadFirstPageFailed() {
        // given
        stub(condition: isPath("/api/v1/surveys")) { _ in
            let path: String! = OHPathForFile("unknown_error.json", type(of: self))
            return HTTPStubsResponse(fileAtPath: path, statusCode: 500, headers: nil)
        }
        sut = container.resolve(HomeViewModel.self)
        
        // when
        sut.trigger.send(())
        
        // then
        expect(self.sut.dataSource).toEventually(beEmpty())
        expect(self.sut.errorMessage).toEventually(equal("Internal Server Error. Please try again later."))
        expect(self.sut.showAlert).toEventually(beTrue())
    }
    
    func testPullToRefresh() {
        // given
        stub(condition: isPath("/api/v1/surveys")) { _ in
            let path: String! = OHPathForFile("default_survey_list_page_1.json", type(of: self))
            return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
        }
        sut = container.resolve(HomeViewModel.self)
        
        // when
        sut.trigger.send(())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.sut.pullToRefresh.send(())
        }
        
        // then
        expect(self.sut.dataSource.count).toEventually(equal(3))
        expect(self.sut.errorMessage).toEventually(beNil())
        expect(self.sut.showAlert).toEventually(beFalse())
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
