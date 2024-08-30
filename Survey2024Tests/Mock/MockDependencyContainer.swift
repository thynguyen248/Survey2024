//
//  MockDependencyContainer.swift
//  Survey2024Tests
//
//  Created by Thy Nguyen on 8/24/24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Survey2024

final class MockDependencyContainer {
    private let container: Container

    init(container: Container = .init()) {
        self.container = container
        registerDependencies()
    }

    private func registerDependencies() {
        // Common
        container.register(KeychainService.self) { resolver in
            MockKeychainService()
        }
        .inObjectScope(.container)

        container.register(APIClient.self) { resolver in
            APIClientImpl(urlSession: URLSession.shared)
        }
        .inObjectScope(.container)

        container.register(TokenProvider.self, factory: { resolver in
            TokenProviderImpl(apiClient: resolver~>, keychainService: resolver~>, userDefaults: UserDefaults(suiteName: "TestSuite")!)
        })
        .inObjectScope(.container)

        container.register(NetworkService.self, factory: { resolver in
            NetworkServiceImpl(apiClient: resolver~>, tokenProvider: resolver~>)
        })
        .inObjectScope(.container)
        
        container.register(LoginRepository.self, factory: { resolver in
            LoginRepositoryImpl(networkService: resolver~>, keychainService: resolver~>)
        })

        container.register(LoginUseCase.self, factory: { resolver in
            LoginUseCaseImpl(repository: resolver~>)
        })
        
        // Splash
        container.register(SplashViewModel.self, factory: { resolver in
            SplashViewModel(useCase: resolver~>)
        })

        // Login
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(useCase: resolver~>)
        }

        // Home
        container.register(SurveyListRepository.self, factory: { resolver in
            SurveyListRepositoryImpl(networkService: resolver~>)
        })

        container.register(SurveyListUseCase.self) { resolver in
            SurveyListUseCaseImpl(repository: resolver~>)
        }

        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(useCase: resolver~>)
        }
    }

    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
