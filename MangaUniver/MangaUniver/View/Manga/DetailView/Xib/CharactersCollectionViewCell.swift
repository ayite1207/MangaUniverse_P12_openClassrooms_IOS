//
//  CharactersCollectionViewCell.swift
//  MangaUniver
//
//  Created by ayite on 14/09/2021.
//

import UIKit

class CharactersCollectionViewCell: UICollectionViewCell {
    
    //MARK: Protperties
    
    var character: Character? {
        didSet {
            if let url = URL(string: character?.imageURL ?? ""){
                if let data = try? Data(contentsOf: url) {
                    characterImage.image = UIImage(data: data)
                    
                }
            }
            characterNameLabel.text = character?.name
        }
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var charactersUIView: UIView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        charactersUIView.raduis(view: charactersUIView, raduis: 35)
        NotificationCenter.default.addObserver(self, selector: #selector(str), name: Notification.Name("GetCharacter"), object: nil)
        
    }
    
    @objc func str(){
        characterNameLabel.backgroundColor = .red
    }
    
}


