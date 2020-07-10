//
//  MovieListTableViewCell.swift
//  MovieGuide
//
//  Created by FIT on 2020/07/08.
//  Copyright © 2020 com.dy. All rights reserved.
//

import UIKit
import SnapKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDetailLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieStarLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layout() {
        movieImageView.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(10)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        
        movieNameLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(movieImageView.snp_rightMargin).offset(10)
            $0.width.equalTo(250)
            $0.height.equalTo(30)
        }
    }

}
