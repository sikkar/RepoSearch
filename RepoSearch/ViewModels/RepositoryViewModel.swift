//
//  RepositoryViewModel.swift
//  RepoSearch
//
//  Created by Angel Escribano on 8/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class RepositoryViewModel: NSObject {

    private let reposService = RepositoryService()
    
    func requestRepositoryDetails(url: String, completion: @escaping(Repository, Error?) -> Void) {
        reposService.getRepositoryDetails(url: url) { repositoryInfo, error in
            if let error = error {
                completion(Repository.init(), error)
            } else {
                completion(repositoryInfo, error)
            }
        }
    }
}
