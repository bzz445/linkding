//
//  Service.swift
//  Linkding
//
//  Created by bzima on 08.01.2023.
//

import Foundation
import Combine

enum ServiceError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case network
    case statusCode(Int)
}

protocol Service {
    var pageLimit: Int { get }
    func getBookmarks(page: Int) -> AnyPublisher<[BookmarkModel], ServiceError>
}
