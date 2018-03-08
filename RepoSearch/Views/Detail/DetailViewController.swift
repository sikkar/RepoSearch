//
//  DetailViewController.swift
//  RepoSearch
//
//  Created by Angel Escribano on 8/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var repoButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var descriptionView: UITextView!
    
    
    var repositoryViewModel: RepositoryViewModel = RepositoryViewModel()
    var publicRepository: PublicRepository?
    private var repositoryDetail: Repository? {
        didSet {
            bindRepositoryDetails()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        obtainRepositoryInfo()
    }

    convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, repository: PublicRepository) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.publicRepository = repository
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        setViewShadows(view: userDataView)
        setViewShadows(view: buttonsView)
    }
    
    private func setViewShadows(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        self.view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 5).cgPath
    }
    
    private func bindRepositoryDetails(){
        self.nameLabel.text = repositoryDetail?.name
        self.userLoginLabel.text = repositoryDetail?.owner?.name
        self.languageLabel.text = repositoryDetail?.language
        if let size = repositoryDetail?.size{
            self.sizeLabel.text = String(describing: size)
        }
        descriptionView.text = repositoryDetail?.description
        if let thumbnail = repositoryDetail?.owner?.avatar, !thumbnail.isEmpty{
            loadThumbnail(thumbnail)
        }
    }
    
    private func loadThumbnail(_ thumbnail: String){
        if let url = URL(string:thumbnail) {
            let placeholderImage = UIImage(named: "placeholder")!
            userImageView.kf.setImage(with: url, placeholder: placeholderImage)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navigationButtonPressed(_ sender: UIButton) {
        if sender == repoButton {
            if let repoUrl = repositoryDetail?.htmlUrl, let url = URL(string:repoUrl) {
                 openSafariWith(url: url)
            }
        } else {
            if let profileUrl = repositoryDetail?.owner?.profileUrl, let url = URL(string: profileUrl) {
                openSafariWith(url: url)
            }
        }
    }
    
    private func openSafariWith(url: URL) {
        UIApplication.shared.open(url, options: [:])
    }
    
    private func obtainRepositoryInfo() {
        if let repoUrl = publicRepository?.apiUrl {
            LoadingOverlay.shared.showOverlay(view: self.view)
            repositoryViewModel.requestRepositoryDetails(url: repoUrl, completion: { [weak self] repositoryInfo, error in
                LoadingOverlay.shared.hideOverlay()
                guard let strongSelf = self else {return}
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    strongSelf.repositoryDetail = repositoryInfo
                }
            })
        }
    }
}
