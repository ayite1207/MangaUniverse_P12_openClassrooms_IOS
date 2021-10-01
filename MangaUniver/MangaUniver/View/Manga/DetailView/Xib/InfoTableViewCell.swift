//
//  InfoTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 08/08/2021.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
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
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstPublicationLabel: UILabel!
    @IBOutlet weak var volumeNumberLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var releaseStackView: UIStackView!
    @IBOutlet weak var volumesStackView: UIStackView!
    @IBOutlet weak var synopsisTitle: UILabel!
    @IBOutlet weak var userCollectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Methodes
    
    @objc func upDateCollection(){
        let volumes = Int(mangaDetail?.volumes ?? 0.0)
        let collection = mangaDetail?.volumes == nil ? "n.c" : String(volumes)
        userCollectionLabel.text = "\(mangaDetail?.number ?? 0) / \(collection)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
