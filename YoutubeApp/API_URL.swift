//
//  API_URL.swift
//  YoutubeApp
//
//  Created by David Thorn on 01.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

public let CHANNEL_ID: String = "UCPMb-9UsPCxwqYGe3lLs29g"

public let PLAYLISTS_URL: URL = URL(string: "https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&channelId=\(CHANNEL_ID)&key=\(API_KEY)&maxResults=50")!

public func PLAYLIST_URL(playlistId: String) -> URL {
    return URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails,snippet&playlistId=\(playlistId)&key=\(API_KEY)&maxResults=50")!
}
