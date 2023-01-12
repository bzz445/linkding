//
//  LinkdingReponse.swift
//  Linkding
//
//  Created by bzima on 08.01.2023.
//

import Foundation

struct LinkdingReponse {
    struct PaginationReponse<T: Codable>: Codable {
        let count: Int
        let next: String?
        let previous: String?
        var results: [T] = []
    }
}

extension LinkdingReponse {
    struct Bookmark: Codable {
        let id: Int
        let url: String
        let title: String
        let description: String
        let webTitle: String?
        let webDescription: String?
        let isArchived: Bool
        let unread: Bool
        let shared: Bool
        let tags: [String]
        let dateAdded: Date?
        let dateModified: Date?
        
        enum CodingKeys: String, CodingKey {
            case id
            case url
            case title
            case description
            case webTitle = "website_title"
            case webDescription = "website_description"
            case isArchived = "is_archived"
            case unread
            case shared
            case tags = "tag_names"
            case dateAdded = "date_added"
            case dateModified = "date_modified"
        }
    }
}
