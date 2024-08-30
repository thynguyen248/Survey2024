//
//  DependencyContainer.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 18/08/2024.
//

import Swinject
import SwinjectAutoregistration
import Foundation

final class DependencyContainer: ObservableObject {
    private let container: Container

    init(container: Container = .init()) {
        self.container = container
        registerDependencies()
    }

    private func registerDependencies() {
        // Common
        container.register(KeychainService.self) { resolver in
            KeychainServiceImpl()
        }
        .inObjectScope(.container)

        container.register(APIClient.self) { resolver in
            let config = URLSessionConfiguration.default
            BearerTokenInterceptor.keychainService = resolver~>
            config.protocolClasses = [BearerTokenInterceptor.self]
            let session = URLSession(configuration: config)
            return APIClientImpl(urlSession: session)
        }
        .inObjectScope(.container)

        container.register(TokenProvider.self, factory: { resolver in
            TokenProviderImpl(apiClient: resolver~>, keychainService: resolver~>)
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
        
        container.register(SplashView.self) { resolver in
            SplashView(viewModel: resolver~>)
        }

        // Login
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(useCase: resolver~>)
        }

        container.register(LoginView.self) { resolver in
            LoginView(viewModel: resolver~>)
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

        container.register(HomeView.self) { resolver in
            HomeView(viewModel: resolver~>)
        }
    }

    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
