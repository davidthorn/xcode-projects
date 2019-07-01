//
//  Snippet.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public struct Snippet: Codable {
    
    public let publishedAt: String
    public let channelId: String
    public let title: String
    public let description: String
    public let thumbnails: Thumbnails
    public let channelTitle: String
    public let localized: LocalizedData
    
    
    
}
