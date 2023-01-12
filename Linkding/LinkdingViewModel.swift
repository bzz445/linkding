//
//  LinkdingViewModel.swift
//  Linkding
//
//  Created by bzima on 08.01.2023.
//

import SwiftUI
import Combine

class LinkdingViewModel: ObservableObject {
    private(set) var service: LinkdingService?
    @Published private(set) var isAuthenticated = false
    @AppStorage("URL") private var url: String = ""
    @AppStorage("TOKEN") private var token: String = ""
    
    init() {
        checkAuthentication()
    }
    
    func signIn(url: String, token: String) {
        self.url = url
        self.token = token
        checkAuthentication()
    }
    
    func signOut() {
        url = ""
        token = ""
        checkAuthentication()
    }
    
    private func checkAuthentication() {
        var result = false
        if !url.isEmpty && !token.isEmpty {
            do {
                service = try LinkdingService(baseURL: url, token: token)
                result = true
            } catch {
                // TODO: show error
                result = false
            }
        }
        
        withAnimation {
            isAuthenticated = result
        }
    }
}
