//
//  QAResponse.swift
//  Assignment3
//
//  Created by Danny on 2020-11-10.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class QAResponse: NSObject, Decodable {
    var answerText: String?
    var media: [Media]?
    
    struct Media: Decodable {
        var title: String?
        var image: String?
        var link: String?
    }
}
