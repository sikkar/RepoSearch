//
//  PagingHandler.swift
//  RepoSearch
//
//  Created by Angel Escribano on 8/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class PagingHandler: NSObject {
    var nextUrl: String = ""
    
    func getNextFromHeader(headers: Dictionary< AnyHashable, Any>) {
        if let linksString = headers["Link"] as? String {
            let linksArray = linksString.split(separator: ",")
            for link in linksArray {
                if link.contains("next") {
                    if let initialPosition = link.index(of: "<"), let finalPosition = link.index(of: ">") {
                        let startPostion = link.index(initialPosition, offsetBy: 1)
                        let range = startPostion..<finalPosition
                        self.nextUrl = String(link[range])
                        break
                    }
                } else {
                    self.nextUrl = ""
                }
            }
        }
    }
}
