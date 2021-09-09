//
//  PhotoTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 04/08/2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var backgroundDetailImageView: UIImageView!
    
    var detailManga: MangaLibrary? {
        didSet {
            if let data = detailManga?.image {
                detailImageView.image = UIImage(data: data)
                detailImageView.raduis(view: detailImageView, raduis: 5)
                backgroundDetailImageView.image = UIImage(data: data)
            }
        }
    } 
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    
}
