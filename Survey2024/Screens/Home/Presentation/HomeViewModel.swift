//
//  HomeViewModel.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    // Input
    let trigger = PassthroughSubject<Void, Never>()
    let pullToRefresh = PassthroughSubject<Void, Never>()

    // Output
    @Published var dataSource: [CardViewModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert = false

    private let useCase: SurveyListUseCase
    private var hasMoreData = true
    private var currentPage: Int = 0
    private let pageSize = 5

    init(useCase: SurveyListUseCase = SurveyListUseCaseImpl()) {
        self.useCase = useCase
        binding()
    }

    private func binding() {
        Publishers.Merge(
            trigger,
            pullToRefresh
                .map { [weak self] _ -> Void in
                    self?.dataSource = []
                    self?.currentPage = 0
                    return ()
                })
        .flatMap { [weak self] _ -> AnyPublisher<[CardViewModel], Never> in
            guard let self, hasMoreData else {
                return Empty().eraseToAnyPublisher()
            }
            isLoading = true
            return Future { promise in
                Task {
                    do {
                        self.currentPage += 1
                        let response = try await self.useCase.getSurveyList(page: self.currentPage, pageSize: self.pageSize)
                        self.hasMoreData = response.hasMoreData
                        let newCards: [CardViewModel] = response.surveys?.map { .init(survey: $0) } ?? []
                        await MainActor.run {
                            self.errorMessage = nil
                            self.showAlert = false
                            self.isLoading = false
                            promise(.success(self.dataSource + newCards))
                        }
                    } catch(let error) {
                        await MainActor.run {
                            self.errorMessage = (error as? AppError)?.errorDescription
                            self.showAlert = !(self.errorMessage ?? "").isEmpty
                            self.isLoading = false
                            promise(.success(self.dataSource))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
        }
        .assign(to: &$dataSource)
    }
}
