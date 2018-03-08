//
//  SearchTableViewCell.swift
//  RepoSearch
//
//  Created by Angel Escribano on 8/3/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var repository: PublicRepository? {
        didSet {
            bindRepository()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.4
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func bindRepository(){
        self.nameLabel.text = repository?.name
        self.descriptionLabel.text = repository?.description
    }
    
}
