//
//  RepositoryService.swift
//  RepoSearch
//
//  Created by Angel Escribano on 7/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

enum Endpoints: String {
    case base = "https://api.github.com/"
    case repositories = "repositories"
    case search = "search/"
}

class RepositoryService: NSObject {
    
    func getPublicRepos(url: String, withKeyPath: Bool = false, completion: @escaping (([PublicRepository], Dictionary< AnyHashable, Any>, Error?) -> Void)){
        
        let keyPath = withKeyPath ? "items" : ""
        
        let request = Alamofire.request(url, method: .get, parameters: nil ,headers: self.getDefaultHeaders())
            .responseArray(queue: DispatchQueue.main, keyPath: keyPath) { (response: DataResponse<[PublicRepository]>) in
                if response.result.isSuccess {
                    if let reposArray = response.result.value, let headers = response.response?.allHeaderFields {
                        completion(reposArray, headers, nil)
                    }
                } else {
                    completion([], [:], response.error)
                }
        }
        print(request.debugDescription)
    }
    
    func getRepositoryDetails(url: String, completion: @escaping ((Repository , Error?) -> Void)){
        let request = Alamofire.request(url, method: .get, parameters: nil , headers: self.getDefaultHeaders())
            .responseObject { (response: DataResponse<Repository>) in
                if response.result.isSuccess {
                    if let repositoryInfo = response.result.value {
                        completion(repositoryInfo,nil)
                    }
                } else {
                    completion(Repository.init(), response.error)
                }
        }
        print(request.debugDescription)
    }
    
    func searchRepositories(term: String, completion: @escaping(([PublicRepository], Dictionary< AnyHashable, Any>, Error?) -> Void)) {
        let searchUrl = Endpoints.base.rawValue + Endpoints.search.rawValue + Endpoints.repositories.rawValue
        let parameters:[String:Any] = ["per_page": 30,
                                       "q":term]
        
        let request = Alamofire.request(searchUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: self.getDefaultHeaders())
            .responseArray(queue: DispatchQueue.main, keyPath: "items") { (response: DataResponse<[PublicRepository]>) in
                if response.result.isSuccess {
                    if let reposArray = response.result.value, let headers = response.response?.allHeaderFields {
                        completion(reposArray, headers, nil)
                    }
                } else {
                    print(response.error.debugDescription)
                    completion([], [:], response.error)
                }
        }
        print(request.debugDescription)
    }
    
    func getDefaultHeaders () -> HTTPHeaders {
        let headers: HTTPHeaders = ["Accept":"application/vnd.github.v3+json"]
        return headers
    }

}
