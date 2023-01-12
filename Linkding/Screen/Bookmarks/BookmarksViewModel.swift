//
//  BookmarksViewModel.swift
//  Linkding
//
//  Created by bzima on 08.01.2023.
//

import SwiftUI
import Combine

class BookmarksViewModel: ObservableObject {
    @Published var isLoading = true
    @Published private(set) var items: [BookmarkModel] = []
    @Published private var page = 0
    private let signOutAction: () -> Void
    private let service: Service
    private var cancellables = Set<AnyCancellable>()
    
    init(service: Service, signOutAction: @escaping () -> Void) {
        self.service = service
        self.signOutAction = signOutAction
        $page
            .dropFirst()
            .sink { page in
                self.isLoading = true
                service.getBookmarks(page: page)
                    .mapError({error in
                        self.isLoading = false
                        return error
                    })
                    .replaceError(with: [])
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { items in
                        self.isLoading = false
                        if page < 2 {
                            self.items = items
                        } else {
                            self.items.append(contentsOf: items)
                        }
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }

    func onRefreshList() {
        page = 1
    }
    
    func onAppearList() {
        page = page + 1
    }
    
    func onAppearIndex(_ index: Int) {
        if index >= service.pageLimit * (page - 1) {
            page = page + 1
        }
    }
    
    func onSignOut() {
        signOutAction()
    }
    
    func fillSampleData() {
        page = 2
        items = [
            BookmarkModel(title: "text 1"),
            BookmarkModel(title: "text 2"),
            BookmarkModel(title: "text 3")
        ]
    }
}
