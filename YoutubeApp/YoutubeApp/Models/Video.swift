//
//  Video.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public struct PlaylistContentDetails: Codable {
    public let videoId: String
    public let videoPublishedAt: String
}

public struct PlaylistItemResource: Codable {
    public let kind: String
    public let videoId: String
}

public struct PlaylistItemSnippet: Codable {
    public let publishedAt: String
    public let channelId: String
    public let title: String
    public let description: String
    public let thumbnails: Thumbnails
    public let channelTitle: String
    public let playlistId: String
    public let position: Int
    public let resourceId: PlaylistItemResource
}

public struct PlaylistItem: Codable {
    public let contentDetails: PlaylistContentDetails
    public let kind: String
    public let etag: String
    public let id: String
    //
    
    //
    //
    public let snippet: PlaylistItemSnippet
}

public struct PlaylistItems: Codable {
    public let kind: String
    public let etag: String
    public let pageInfo: PageInfo
    public let items: [PlaylistItem]
    //
    //
    
    
}
