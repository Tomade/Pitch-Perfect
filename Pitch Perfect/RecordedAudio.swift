//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Danilo Fiorenzano on 5/8/2015.
//  Copyright (c) 2015 Danilo Fiorenzano. All rights reserved.
//

import Foundation
class RecordedAudio {
    let filePathUrl: NSURL!
    let title: String!
    
    init(url: NSURL, title: String) {
        self.filePathUrl = url
        self.title = title
    }
}