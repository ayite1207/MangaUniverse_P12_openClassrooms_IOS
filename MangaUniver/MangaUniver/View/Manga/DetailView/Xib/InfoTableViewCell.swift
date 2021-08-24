//
//  InfoTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 08/08/2021.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstPublicationLabel: UILabel!
    @IBOutlet weak var volumeNumberLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var mangaDetail : MangaLibrary? {
        didSet{
            firstPublicationLabel.text = mangaDetail?.publishingStart
            let volumes = Int(mangaDetail?.volumes ?? 0.0)
            volumeNumberLabel.text = "\(volumes )"
            synopsisLabel.numberOfLines = 0
            synopsisLabel.text = mangaDetail?.synopsis
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
