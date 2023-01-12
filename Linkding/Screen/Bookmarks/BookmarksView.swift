//
//  BookmarksView.swift
//  Linkding
//
//  Created by bzima on 08.01.2023.
//

import SwiftUI

struct BookmarksView: View {
    @ObservedObject fileprivate var viewModel: BookmarksViewModel
    
    init(service: Service, signOutAction: @escaping () -> Void) {
        self.viewModel = BookmarksViewModel(service: service, signOutAction: signOutAction)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.items.enumerated().map({ $0 }), id: \.element.id) { index, item in
                        Text(item.title)
                            .onAppear {
                                viewModel.onAppearIndex(index)
                            }
                    }
                } footer: {
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            Text("Loading...")
                            Spacer()
                        }
                    }
                }
            }
            .refreshable {
                viewModel.onRefreshList()
            }
            .onAppear {
                viewModel.onAppearList()
            }
            .navigationTitle("Linkding")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Sign out") {
                        viewModel.onSignOut()
                    }
                }
            }
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var service = try! LinkdingService(baseURL: "url", token: "token")
    static var view = BookmarksView(service: service, signOutAction: {})
    static var previews: some View {
        view.onAppear {
            view.viewModel.fillSampleData()
        }
    }
}
