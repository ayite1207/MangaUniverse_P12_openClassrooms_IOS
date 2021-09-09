//
//  LibraryTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 15/08/2021.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var mangUIImage: UIImageView!
    @IBOutlet weak var mangaTitleLabel: UILabel!
    
    var mangaLibrary : MangaLibrary? {
        didSet{
            mangaTitleLabel.text = mangaLibrary?.title
            if let data = mangaLibrary?.image {
                mangUIImage.image = UIImage(data: data)
                mangUIImage.raduis(view: mangUIImage, raduis: 5)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = .systemPink
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
