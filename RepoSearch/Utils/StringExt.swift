//
//  StringExt.swift
//  RepoSearch
//
//  Created by Angel Escribano on 8/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
