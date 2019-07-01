//
//  Playlist.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public struct PageInfo: Codable {
    public let totalResults: Int
    public let resultsPerPage: Int
}

public struct Playlists: Codable {
    public let kind: String
    public let etag: String
    public let items: [Playlist]
    public let pageInfo: PageInfo
}

public struct Playlist: Codable {
    public let kind: String
    public let etag: String
    public let id: String
    public let snippet: Snippet
    public let contentDetails: ContentDetails
}
