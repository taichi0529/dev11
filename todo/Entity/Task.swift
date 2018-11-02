//
//  Task.swift
//  todo
//
//  Created by 中村太一 on 2018/09/22.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class Task: Codable {
    var id: String?
    var title: String?
    var note: String?
    var latitude: Double?
    var longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case title
        case note
        case latitude
        case longitude
    }
    
    init(title _title: String) {
        self.title = _title
    }
    
    init(data: [String: Any]) {
        if let title = data["title"] as? String {
            self.title = title
        }
        if let note = data["note"] as? String {
            self.note = note
        }
        if let latitude = data["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = data["longitude"] as? Double {
            self.longitude = longitude
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.note = try container.decode(String.self, forKey: .note)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(note, forKey: .note)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    func toData() -> [String: Any] {
        return [
            "title": self.title!,
            "note": self.note!,
            "latitude": self.latitude!,
            "longitude": self.longitude!
        ]
    }
    
}
