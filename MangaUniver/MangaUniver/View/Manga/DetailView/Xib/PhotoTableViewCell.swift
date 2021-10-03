//
//  PhotoTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 04/08/2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var backgroundDetailImageView: UIImageView!
    
    // MARK: - Properties
    
    var detailManga: MangaLibrary? {
        didSet {
            if let data = detailManga?.image {
                detailImageView.image = UIImage(data: data)
                detailImageView.raduis(view: detailImageView, raduis: 5)
                backgroundDetailImageView.image = UIImage(data: data)
            }
        }
    }
    
    var character: CharacterDetails? {
        didSet {
            if let data = character?.imageURL.data {
                detailImageView.image = UIImage(data: data)
                detailImageView.raduis(view: detailImageView, raduis: 5)
                backgroundDetailImageView.image = UIImage(data: data)
            }
        }
    }

}
