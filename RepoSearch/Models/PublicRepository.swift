//
//  PublicRepository.swift
//  RepoSearch
//
//  Created by Angel Escribano on 7/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import ObjectMapper

struct PublicRepository: Mappable {
    
    var id: Int?
    var name: String?
    var htmlUrl: String?
    var apiUrl: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.htmlUrl <- map["html_url"]
        self.apiUrl <- map["url"]
    }
    
}

