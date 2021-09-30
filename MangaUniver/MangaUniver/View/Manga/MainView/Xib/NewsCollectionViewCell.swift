//
//  NewsCollectionViewCell.swift
//  MangaUniver
//
//  Created by ayite on 05/07/2021.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - outlets
    
    @IBOutlet weak var topMangaClassementLabel: UILabel!
    @IBOutlet weak var backgroundTopMangaImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var topMangaTitleLabel: UILabel!
    
    // MARK: - protperties
    
    var topManga : Top? {
        didSet {
            topMangaClassementLabel.text = "N° \(String(topManga?.rank ?? 0))"
            if let url = URL( string: topManga?.imageURL ?? ""){
                  if let data = try? Data( contentsOf:url)
                  {
                    backgroundTopMangaImageView.image = UIImage(data: data)
                      mainImageView.image = UIImage(data: data)
                      mainImageView.raduis(view: mainImageView, raduis: 5)
                      backgroundTopMangaImageView.raduis(view: mainImageView, raduis: 5)
                  }
            }
            topMangaTitleLabel.text = topManga?.title
        }
    }


}
