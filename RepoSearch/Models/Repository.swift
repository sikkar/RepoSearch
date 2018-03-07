//
//  Repository.swift
//  RepoSearch
//
//  Created by Angel Escribano on 7/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import ObjectMapper

struct Repository: Mappable {
    
    var id: Int?
    var name: String?
    var owner: Owner?
    var htmlUrl: String?
    var language: String?
    var size: Int?
    var description: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.owner <- map["owner"]
        self.htmlUrl <- map["html_url"]
        self.language <- map["language"]
        self.size <- map["size"]
        self.description <- map["description"]
    }
}
