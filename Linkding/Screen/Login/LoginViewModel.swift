//
//  LoginViewModel.swift
//  Linkding
//
//  Created by bzima on 05.01.2023.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    private let saveAction: (_ url: String, _ token: String) -> Void
    @Published private(set) var isValid = false
    @Published var url: String = "" {
        didSet {
            validate()
        }
    }
    @Published var token: String = "" {
        didSet {
            validate()
        }
    }
  
    init(saveAction: @escaping (_: String, _: String) -> Void) {
        self.saveAction = saveAction
    }

    func save() {
        if isValid {
            saveAction(url, token)
        }
    }
    
    private func validate() {
        isValid = !url.isEmpty && !token.isEmpty
    }
}
