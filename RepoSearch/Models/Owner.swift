//
//  Owner.swift
//  RepoSearch
//
//  Created by Angel Escribano on 7/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import ObjectMapper

struct Owner: Mappable {
    
    var id: Int? = 0
    var name: String? = ""
    var avatar: String? = ""
    var profileUrl: String? = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["login"]
        self.profileUrl <- map["html_url"]
        self.avatar <- map["avatar_url"]
    }
}
