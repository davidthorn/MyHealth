//
//  MyHealthApp.swift
//  MyHealth
//
//  Created by David Thorn on 30.01.26.
//

import SwiftUI

@main
public struct MyHealthApp: App {
    private let services: AppServicesProviding

    public init() {
        self.services = AppServices.live()
    }

    public var body: some Scene {
        WindowGroup {
            ContentView(services: services)
                .task {
                    await services.loadStores()
                }
        }
    }
}
