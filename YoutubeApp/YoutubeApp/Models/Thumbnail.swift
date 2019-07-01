//
//  Thumbnail.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public struct ThumbnailUrl: Codable {
    public let url: URL
    public let width: Int
    public let height: Int
}

public struct Thumbnails: Codable {
    
    public var `default`: ThumbnailUrl?
    public let medium: ThumbnailUrl?
    public let high: ThumbnailUrl?
    public let standard: ThumbnailUrl?
    public let maxres: ThumbnailUrl?
    
}
