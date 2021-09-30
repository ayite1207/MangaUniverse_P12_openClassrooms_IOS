//
//  LibraryCollectionViewCell.swift
//  MangaUniver
//
//  Created by ayite on 29/08/2021.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell{
    
    //MARK: Prpoerties
    
    var mangaLibrary : [MangaLibrary]?{
        didSet {
            listMangaCoreDataTableView.reloadData()
        }
    }
    
    var isLibraryMangas = true
    var onDidSelectItem: ((IndexPath) -> ())?
    
    //MARK: Outlets
    
    @IBOutlet weak var listMangaCoreDataTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listMangaCoreDataTableView.delegate = self
        listMangaCoreDataTableView.dataSource = self
        listMangaCoreDataTableView.register(UINib(nibName: "LibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "LibraryTableViewCell")
        // Initialization code
    }
    
}

//MARK: TableView

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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        
        if isLibraryMangas {
            label.text = mangaLibrary?.filter({ $0.islibraryManga == true}).count ?? 0 > 0 ? "": "Add some tasks in the list"
        } else {
            label.text = mangaLibrary?.filter({ $0.isMangaFollow == true}).count ?? 0 > 0 ? "": "Add some tasks in the list"
        }
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var manga = 0
        if isLibraryMangas {
            manga = mangaLibrary?.filter({ $0.islibraryManga == true}).count == 0 ? 200 : 0

        } else {
            manga = mangaLibrary?.filter({ $0.isMangaFollow == true}).count ?? 0 > 0 ? 200 : 0
        }

        return CGFloat(manga)
    }
}
