//
//  LibraryTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 15/08/2021.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

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
    
}
