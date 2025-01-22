//
//  LifeCycleApp.swift
//  LifeCycle
//
//  Created by Leandro Oliveira on 22/1/25.
//

import SwiftUI

@main
struct LifeCycleApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .background:
                print("App is in Background State")
            case .inactive:
                print("App is in Inactive State")
            case .active:
                print("App is in Active State")
            @unknown default:
                print("Unknown State")
            }
        }
    }
}
