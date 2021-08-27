//
//  NewsTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 05/07/2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    var mangaTopPopularity : MangaTopPopularity? {
        didSet {
            newsCollectionView.reloadData()
        }
    }
    
    var onDidSelectItem: ((IndexPath) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.newsCollectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
        self.newsCollectionView.delegate = self
        self.newsCollectionView.dataSource = self
        self.newsCollectionView.backgroundColor = .white
        if #available(iOS 13.0, *) {
            self.newsCollectionView.collectionViewLayout = createLayout()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension NewsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell() }
        cell.topManga = mangaTopPopularity?.top[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onDidSelectItem?(indexPath)
    }
    
    @available(iOS 13.0, *)
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 15.0, trailing: 15.0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
            
            section.orthogonalScrollingBehavior = .paging
            
            return section
        }
        
        return layout
    }
    
    
    
}
