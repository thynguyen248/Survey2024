//
//  SplashViewModel.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 19/08/2024.
//

import Foundation
import Combine

enum Destination: String {
    case login
    case home
}

final class SplashViewModel: ObservableObject {
    // Input
    let trigger = PassthroughSubject<Void, Never>()

    // Output
    @Published var navigationSelection: Destination?

    private let useCase: LoginUseCase

    init(useCase: LoginUseCase = LoginUseCaseImpl()) {
        self.useCase = useCase
        binding()
    }

    func binding() {
        trigger
            .map { [weak self] _ -> Destination? in
                guard let self else {
                    return nil
                }
                return useCase.isLoggedIn ? .home : .login
            }
            .eraseToAnyPublisher()
            .assign(to: &$navigationSelection)
    }
}
