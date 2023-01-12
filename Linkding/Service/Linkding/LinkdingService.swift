//
//  LinkdingService.swift
//  Linkding
//
//  Created by bzima on 08.01.2023.
//

import Foundation
import Combine

class LinkdingService {
    var timeoutInterval: TimeInterval = 10.0
    
    private(set) var pageLimit = 100
    
    private enum EndPoint: String {
        case bookmarks = "bookmarks"
    }
    
    private enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    typealias Bookmarks = LinkdingReponse.PaginationReponse<LinkdingReponse.Bookmark>
    
    private let baseURL: URL
    private var headers = [
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
    ]
    private var session: URLSession
    private var decoder: JSONDecoder
    
    init(baseURL: String, token: String) throws {
        guard let url = URL(string: baseURL) else {
            throw ServiceError.invalidUrl
        }
        self.baseURL = url
        headers["Authorization"] = "Token \(token)"
        session = URLSession.shared
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    private func prepare(endPoint: EndPoint, method: HttpMethod, body: Data? = nil) -> URLRequest {
        var url = baseURL
        url.append(path: endPoint.rawValue, directoryHint: .isDirectory)
        url.append(queryItems: [URLQueryItem(name: "format", value: "json")])
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
    
    private func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw ServiceError.statusCode(httpResponse.statusCode)
        }
        return data
    }
}

extension LinkdingService: Service {
    func getBookmarks(page: Int) -> AnyPublisher<[BookmarkModel], ServiceError> {
        var request = prepare(endPoint: .bookmarks, method: .get)
        request.url?.append(queryItems: [URLQueryItem(name: "limit", value: "\(pageLimit)")])
        request.url?.append(queryItems: [URLQueryItem(name: "offset", value: "\(pageLimit * (page - 1))")])
        return session.dataTaskPublisher(for: request)
            .mapError { error -> ServiceError in
                .network
             }
            .tryMap { try self.validate($0.data, $0.response) }
            .decode(type: Bookmarks.self, decoder: decoder)
            .mapError { error -> ServiceError in
                .invalidData
            }
            .map({$0.results.map({BookmarkModel(title: $0.webTitle ?? "no title")})})
            .eraseToAnyPublisher()
    }
}
