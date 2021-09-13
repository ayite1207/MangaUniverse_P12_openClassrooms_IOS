//
//  DetailTitleTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 06/08/2021.
//

import UIKit
import CoreData

class DetailTitleTableViewCell: UITableViewCell {
    
    
    //MARK: - Properties
    
    var isLibraryManga = false
    var isFollowManga = false
    
    var mangaDetail: MangaLibrary? {
        didSet {
            detailTitleManga.text = mangaDetail?.title
            setButtonTilte()
        }
    }
    
    private var coreDataManager: CoreDataManager?

    
    var onDidSelectItem: ((_ manga: MangaLibrary, _ isLibrary: Bool, _ value: Bool) -> ())?
    
    //MARK: - Outlets
    
    @IBOutlet weak var detailTitleManga: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataMangaCollection = appdelegate.coreDataMangaCollection
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)

        setButton()
    }
    
    //MARK: - Action

    @IBAction func addManga(_ sender: Any) {
        guard let mangaToSave = mangaDetail else { return }
        self.onDidSelectItem?(mangaToSave, true, !isLibraryManga)
        setButtonTilte()
    }

    
    @IBAction func followManga(_ sender: Any) {
        guard let mangaToSave = mangaDetail else { return }
        self.onDidSelectItem?(mangaToSave, false, !isFollowManga)
    }
    
    //MARK: - Methodes
    
    
    
    func setButton() {
        addButton.raduis(view: addButton, raduis: 15)
        addButton.border(view: addButton, color: UIColor.red.cgColor)
        addButton.tintColor = .red
        followButton.raduis(view: followButton, raduis: 15)
        followButton.border(view: followButton, color: UIColor.green.cgColor)
        followButton.tintColor = .green
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func checkIfEntityExist() -> Bool{
       
        guard let title = mangaDetail?.title, let checkIfEntityExist = coreDataManager?.entityExist(title: title) else { return false}
            return checkIfEntityExist
        
    }
    
    private func setButtonTilte(){
        if let manga = coreDataManager?.mangaCollection.filter({ $0.title == mangaDetail?.title}).first {
            addButton.setTitle(manga.isLibraryManga == true ? "Update" : "Add" , for: .normal)
            isLibraryManga = manga.isLibraryManga
            followButton.setTitle(manga.isFollowManga == true  ? "Unfollow" : "follow", for: .normal)
            isFollowManga = manga.isFollowManga
        } else {
            addButton.setTitle( "Add" , for: .normal)
            followButton.setTitle( "follow", for: .normal)
        }
        
    }
    
}
