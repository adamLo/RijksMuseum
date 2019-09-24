//
//  ArtCell.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit
import Kingfisher

/*!
 * @brief Displays a thumbnal of an artwork with title and artist name
 */
class ArtCell: UICollectionViewCell {
    
    static let reuseId = "artCell"
    
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        titleLabel.font = UIFont.defaultFont(style: .regular, size: .small)
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        artistLabel.font = UIFont.defaultFont(style: .italic, size: .xSmall)
        artistLabel.textColor = UIColor.black
        artistLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }
    
    /*!
     * @brief Set up cell with an ArtWork object
     *
     * @param artObject ArtObject instance from cache
     */
    func setup(with artObject: ArtObject) {
        
        if let url = artObject.headerImageURL {
            artImageView.kf.setImage(with: url)
        }
        
        artistLabel.text = artObject.principalOrFirstMaker
        titleLabel.text = artObject.title
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        artImageView.image = nil
        artistLabel.text = nil
        titleLabel.text = nil
    }
}
