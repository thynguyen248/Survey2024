//
//  LoginViewModelTests.swift
//  Survey2024Tests
//
//  Created by Thy Nguyen on 8/24/24.
//

import XCTest
import Nimble
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Survey2024

final class LoginViewModelTests: XCTestCase {
    private var sut: LoginViewModel!
    private let container = MockDependencyContainer()
    
    func testEmptyEmailAndPassword() {
        // given
        sut = container.resolve(LoginViewModel.self)
        
        // when
        sut.email = ""
        sut.password = ""
        sut.didLogin.send(())
        
        // then
        expect(self.sut.emailErrorMessage).toEventually(equal("Email cannot be empty."))
        expect(self.sut.passwordErrorMessage).toEventually(equal("Password cannot be empty."))
        expect(self.sut.loggedIn).toEventually(beFalse())
        expect(self.sut.errorMessage).toEventually(beNil())
        expect(self.sut.showAlert).toEventually(beFalse())
    }
    
    func testInvalidEmailAndEmptyPassword() {
        // given
        sut = container.resolve(LoginViewModel.self)
        
        // when
        sut.email = "123"
        sut.didLogin.send(())
        
        // then
        expect(self.sut.emailErrorMessage).toEventually(equal("Please enter a valid email address."))
        expect(self.sut.passwordErrorMessage).toEventually(equal("Password cannot be empty."))
        expect(self.sut.loggedIn).toEventually(beFalse())
        expect(self.sut.errorMessage).toEventually(beNil())
        expect(self.sut.showAlert).toEventually(beFalse())
    }
    
    func testLoginSuccessFully() {
        // given
        stub(condition: isPath("/api/v1/oauth/token")) { _ in
            let path: String! = OHPathForFile("default_login.json", type(of: self))
            return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
        }
        sut = container.resolve(LoginViewModel.self)
        
        // when
        sut.email = "abc@mail.com"
        sut.password = "123"
        sut.didLogin.send(())
           
        // then
        expect(self.sut.emailErrorMessage).toEventually(beNil())
        expect(self.sut.passwordErrorMessage).toEventually(beNil())
        expect(self.sut.loggedIn).toEventually(beTrue())
        expect(self.sut.errorMessage).toEventually(beNil())
        expect(self.sut.showAlert).toEventually(beFalse())
    }
    
    func testLoginFailed() {
        // given
        stub(condition: isPath("/api/v1/oauth/token")) { _ in
            let path: String! = OHPathForFile("failed_login.json", type(of: self))
            return HTTPStubsResponse(fileAtPath: path, statusCode: 400, headers: nil)
        }
        sut = container.resolve(LoginViewModel.self)
        
        // when
        sut.email = "abc@mail.com"
        sut.password = "123"
        sut.didLogin.send(())
        
        // then
        expect(self.sut.emailErrorMessage).toEventually(beNil())
        expect(self.sut.passwordErrorMessage).toEventually(beNil())
        expect(self.sut.loggedIn).toEventually(beFalse())
        expect(self.sut.errorMessage).toEventually(equal("Your email or password is incorrect. Please try again."))
        expect(self.sut.showAlert).toEventually(beTrue())
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
