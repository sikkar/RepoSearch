//
//  RespositoryViewModel.swift
//  RepoSearch
//
//  Created by Angel Escribano on 7/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class PublicRepositoryViewModel: NSObject {
    
    private let reposService = RepositoryService()
    private var publicRepos: PagingHandler = PagingHandler()
    var publicReposList: [PublicRepository] = []
    var searchActive: Bool = false

    func requestAllPublicRepositories(completion: @escaping((Error?) -> Void)){
        let url = Endpoints.base.rawValue + Endpoints.repositories.rawValue
        publicRepos.nextUrl = ""
        reposService.getPublicRepos(url: url) { [weak self] repositories, headers, error in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error)
            } else {
                strongSelf.publicRepos.getNextFromHeader(headers:headers)
                strongSelf.publicReposList = repositories
                completion(nil)
            }
        }
    }
    
    func requestMorePublicRepositories(completion: @escaping((Error?) -> Void)){
        if !publicRepos.nextUrl.isEmpty {
            reposService.getPublicRepos(url: publicRepos.nextUrl, withKeyPath: searchActive, completion: { [weak self] repositories, headers, error in
                guard let strongSelf = self else {return}
                if let error = error {
                    completion(error)
                } else {
                    strongSelf.publicRepos.getNextFromHeader(headers:headers)
                    strongSelf.publicReposList.append(contentsOf: repositories)
                    completion(nil)
                }
            })
        }
    }
    
    func requestSearchRepositories(term: String, completion: @escaping((Error?) -> Void)) {
        publicRepos.nextUrl = ""
        reposService.searchRepositories(term: term) { [weak self] reposFound, headers, error in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error)
            } else {
                strongSelf.publicRepos.getNextFromHeader(headers:headers)
                strongSelf.publicReposList = reposFound
                completion(nil)
            }
        }
    }
    
}
