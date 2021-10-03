//
//  GenderTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 06/07/2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var genderCollectionView: UICollectionView!
    var onDidSelectItem: ((IndexPath, _ manga: MangaLibrary) -> ())?
    
    // MARK: - Property

    var listGenreManga : [MangaLibrary]? {
        didSet {
            genderCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.genderCollectionView.delegate = self
        self.genderCollectionView.dataSource = self
        genderCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - TableView

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell() }
        cell.categoryManga = listGenreManga?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let manga = listGenreManga?[indexPath.row] else { return }
        self.onDidSelectItem?(indexPath, manga )
    }
    
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.height - 20) / 1.5, height: (collectionView.frame.size.height))
       }
    
}
