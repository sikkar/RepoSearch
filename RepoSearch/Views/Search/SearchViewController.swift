//
//  SearchViewController.swift
//  RepoSearch
//
//  Created by Angel Escribano on 7/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var reposTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var publicRepositoryViewModel = PublicRepositoryViewModel()
    private let reposCellIdentifier = "reposCellIdentifier"
    var searchActive: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()
        
    }
    
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        reposTableView.dataSource = self
        reposTableView.delegate = self
        reposTableView.register(UINib.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: reposCellIdentifier)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func bindViewModel(){
        LoadingOverlay.shared.showOverlay(view: self.view)
        publicRepositoryViewModel.requestAllPublicRepositories { [weak self] error in
            LoadingOverlay.shared.hideOverlay()
            guard let strongSelf = self else {return}
            if let gotError = error {
                print(gotError.localizedDescription)
            } else {
                strongSelf.reloadTableView()
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.count == 0){
            publicRepositoryViewModel.searchActive = false
            bindViewModel()
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchTextField.resignFirstResponder()
        if let text = searchTextField.text, text.trimmingCharacters(in: .whitespaces) != "" {
            LoadingOverlay.shared.showOverlay(view: self.view)
            publicRepositoryViewModel.searchActive = true
            publicRepositoryViewModel.requestSearchRepositories(term: text) { [weak self] error in
                LoadingOverlay.shared.hideOverlay()
                guard let strongSelf = self else {return}
                if let gotError = error {
                    print(gotError.localizedDescription)
                } else {
                    strongSelf.reloadTableView()
                }
            }
        }
        
    }
    
    private func loadMoreRepositories() {
        publicRepositoryViewModel.requestMorePublicRepositories { [weak self] error in
            guard let strongSelf = self else {return}
            if let gotError = error {
                print(gotError.localizedDescription)
            } else {
                strongSelf.reposTableView.reloadData()
            }
        }
    }
    
    private func reloadTableView(){
        reposTableView.reloadData()
        if publicRepositoryViewModel.publicReposList.count > 0 {
            let indexPath = IndexPath.init(row: 0, section: 0)
            reposTableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.resignFirstResponder()
        let repository = publicRepositoryViewModel.publicReposList[indexPath.section]
        let detailViewController = DetailViewController.init(nibName: "DetailViewController", bundle: nil, repository: repository)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == publicRepositoryViewModel.publicReposList.count - 1) {
            loadMoreRepositories()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reposCellIdentifier, for: indexPath) as? SearchTableViewCell else {
             return UITableViewCell()
        }
        
        cell.repository = publicRepositoryViewModel.publicReposList[indexPath.section]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return publicRepositoryViewModel.publicReposList.count
    }
    
}
