//
//  MediaItem.swift
//  MediaPlayerApp-UIKit
//
//  Created by 박지혜 on 7/8/24.
//

import Foundation

struct MediaItem {
    let url: URL
    let title: String
    let isVideo: Bool
}

extension MediaItem {
    static let samples = [
        MediaItem(url: Bundle.main.url(forResource: "AudioSample1", withExtension: "mp3")!, title: "sample", isVideo: false),
        MediaItem(url: Bundle.main.url(forResource: "AudioSample2", withExtension: "mp3")!, title: "sample2", isVideo: false),
        MediaItem(url: Bundle.main.url(forResource: "AudioSample3", withExtension: "mp3")!, title: "Small World", isVideo: false),
        MediaItem(url: Bundle.main.url(forResource: "VideoSample1", withExtension: "mp4")!, title: "Bigbang - Monster", isVideo: true),
        MediaItem(url: Bundle.main.url(forResource: "VideoSample2", withExtension: "mov")!, title: "Samsung Premiere 2013 Opening", isVideo: true),
        MediaItem(url: Bundle.main.url(forResource: "VideoSample3", withExtension: "mov")!, title: "SaturnV", isVideo: true)
        
//        MediaItem(url: URL(string:"https://samplelib.com/lib/preview/mp3/sample-3s.mp3")!, title: "Short MP3 Sample", isVideo: false),
//        MediaItem(url: URL(string:"https://filesamples.com/samples/video/mp4/sample_640x360.mp4")!, title: "Medium MP4 Sample", isVideo: true),
//        MediaItem(url: URL(string:"https://filesamples.com/samples/video/mp4/sample_960x540.mp4")!, title: "Large MP4 Sample", isVideo: true),
    ]
}
