//
//  LibraryCollectionViewCell.swift
//  MangaUniver
//
//  Created by ayite on 29/08/2021.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell{
    
    var mangaLibrary : [MangaLibrary]?{
        didSet {
            listMangaCoreDataTableView.reloadData()
        }
    }
    var onDidSelectItem: ((IndexPath) -> ())?
    
    @IBOutlet weak var listMangaCoreDataTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listMangaCoreDataTableView.delegate = self
        listMangaCoreDataTableView.dataSource = self
        listMangaCoreDataTableView.register(UINib(nibName: "LibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "LibraryTableViewCell")
        // Initialization code
    }
    
}

extension LibraryCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaLibrary?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell", for: indexPath) as? LibraryTableViewCell else { return UITableViewCell() }
        guard let mangaLibrary = mangaLibrary else { return UITableViewCell() }
        cell.mangaLibrary = mangaLibrary[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onDidSelectItem?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
