//
//  Survey2024App.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import SwiftUI

@main
struct Survey2024App: App {
    let container: DependencyContainer = .init()

    var body: some Scene {
        WindowGroup {
            container.resolve(SplashView.self)
                .environmentObject(container)
        }
    }
}
