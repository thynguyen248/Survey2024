//
//  SplashViewModelTests.swift
//  Survey2024Tests
//
//  Created by Thy Nguyen on 8/24/24.
//

import XCTest
import Nimble
@testable import Survey2024

final class SplashViewModelTests: XCTestCase {
    private var sut: SplashViewModel!
    private let container = MockDependencyContainer()

    func testDestinationViewLogin() {
        // given
        sut = container.resolve(SplashViewModel.self)
        
        // when
        sut.trigger.send(())
        
        // then
        expect(self.sut.navigationSelection).toEventually(equal(.login))
    }
    
    func testDestinationViewHome() {
        // given
        let mockKeychainService = MockKeychainService(hasAccessToken: true)
        let repo = LoginRepositoryImpl(networkService: NetworkServiceImpl(), keychainService: mockKeychainService)
        sut = SplashViewModel(useCase: LoginUseCaseImpl(repository: repo))
        
        // when
        sut.trigger.send(())
        
        // then
        expect(self.sut.navigationSelection).toEventually(equal(.home))
    }
}
