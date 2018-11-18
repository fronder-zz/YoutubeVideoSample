//
//  VideoTableViewCell.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import SDWebImage

protocol VideoTableViewCellDelegate {
    func videoTableViewCellPlayDidClick(object: VideoObject)
}

class VideoTableViewCell: UITableViewCell {

    static var reuseIdentifier: String {
        return "\(self)"
    }
    
    
    // MARK: IBOutlets/Variables
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate var object: VideoObject!
    var delegate: VideoTableViewCellDelegate?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

   
    // MARK: Public
    
    func setModel(model: VideoObject) {
        self.object = model
        
        self.titleLabel.text = model.title
        if let urlString = model.thumbnailImageUrlString(resolution: .medium) {
            self.thumbnailImageView?.sd_setImage(with: URL(string: urlString), placeholderImage: nil)
        }
    }

    
    @IBAction func playButtonDidClick(_ sender: Any) {
        self.delegate?.videoTableViewCellPlayDidClick(object: self.object)
    }
}
