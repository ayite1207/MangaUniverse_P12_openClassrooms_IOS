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
    @IBOutlet weak var releaseStackView: UIStackView!
    @IBOutlet weak var volumesStackView: UIStackView!
    @IBOutlet weak var synopsisTitle: UILabel!
    @IBOutlet weak var userCollectionLabel: UILabel!
    
    var mangaDetail : MangaLibrary? {
        didSet{
            firstPublicationLabel.text = mangaDetail?.publishingStart
            let volumes = Int(mangaDetail?.volumes ?? 0.0)
            volumeNumberLabel.text = "\(volumes )"
            synopsisLabel.numberOfLines = 0
            synopsisLabel.text = mangaDetail?.synopsis
            let collection = mangaDetail?.volumes == nil ? "n.c" : String(volumes)
            userCollectionLabel.text = "\(mangaDetail?.number ?? 0) / \(collection)"
        }
    }
    
    var character: CharacterDetails? {
        didSet {
            synopsisLabel.numberOfLines = 0
            synopsisLabel.text = character?.about
            releaseStackView.isHidden = true
            volumesStackView.isHidden = true
            synopsisTitle.text = "About :"
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
