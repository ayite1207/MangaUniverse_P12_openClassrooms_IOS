//
//  NewsCollectionViewCell.swift
//  MangaUniver
//
//  Created by ayite on 05/07/2021.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {    
    
    @IBOutlet weak var topMangaClassementLabel: UILabel!
    @IBOutlet weak var topMangaImageView: UIImageView!
    @IBOutlet weak var topMangaTitleLabel: UILabel!
    @IBOutlet weak var topMangaDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var topManga : Top? {
        didSet {
            topMangaClassementLabel.text = "N° \(String(topManga?.rank ?? 0))"
            if let url = URL( string: topManga?.imageURL ?? ""){
                  if let data = try? Data( contentsOf:url)
                  {
                    topMangaImageView.image = UIImage(data: data)
                  }
            }
            topMangaTitleLabel.text = topManga?.title
        }
    }


}
