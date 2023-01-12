//
//  LinkdingApp.swift
//  Linkding
//
//  Created by bzima on 05.01.2023.
//

import SwiftUI

@main
struct LinkdingApp: App {
    @StateObject private var model = LinkdingViewModel()
    
    var body: some Scene {
        WindowGroup {
            if model.isAuthenticated {
                if let service = model.service {
                    BookmarksView(service: service, signOutAction: model.signOut).zIndex(1)
                } else {
                    Text("error")
                    // TODO: show unknown error
                }
            } else {
                LoginView(saveAction: model.signIn)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                    .zIndex(0)
            }
        }
    }
}
