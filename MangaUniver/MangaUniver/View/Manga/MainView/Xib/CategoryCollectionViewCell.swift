//
//  CategoryCollectionViewCell.xib.swift
//  MangaUniver
//
//  Created by ayite on 06/07/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mangaImage: UIImageView!
    @IBOutlet weak var titleMangaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var categoryManga : MangaLibrary? {
        didSet {
            if let data = categoryManga?.image {
                mangaImage.image = UIImage(data: data)
                mangaImage.backgroundColor = .gray
                mangaImage.raduis(view: mangaImage, raduis: 3)
            }
            titleMangaLabel.text = categoryManga?.title
        }
    }
    
    var manga : TopManga? {
        didSet {
            if let data = manga?.image {
                mangaImage.image = UIImage(data: data)
            }
            titleMangaLabel.text = manga?.title
        }
    }
}
