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
    
    var mangaCollection = "MangaCollection"
    var mangaFollow = "MangaFollow"
    
    var mangaDetail: MangaLibrary? {
        didSet {
            detailTitleManga.text = mangaDetail?.title
            setButtonTilte()
        }
    }
    
    private var coreDataManager: CoreDataManager?

    
    var onDidSelectItem: ((MangaLibrary, _ isLibrary: Bool) -> ())?
    
    //MARK: - Outlets
    
    @IBOutlet weak var detailTitleManga: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataMangaCollection = appdelegate.coreDataMangaCollection
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)
        
        addButton.raduis(view: addButton, raduis: 20)
        addButton.border(view: addButton, color: UIColor.black.cgColor)
        followButton.raduis(view: followButton, raduis: 20)
        followButton.border(view: followButton, color: UIColor.black.cgColor)
        
    }

    @IBAction func addManga(_ sender: Any) {
        guard let mangaToSave = mangaDetail else { return }
        self.onDidSelectItem?(mangaToSave, true)
        addButton.setTitle( !checkIfEntityExist() ? "Pull" : "Add" , for: .normal)
    }

    
    @IBAction func followManga(_ sender: Any) {
        guard let mangaToSave = mangaDetail else { return }
        self.onDidSelectItem?(mangaToSave, false)
        followButton.setTitle(!checkIfEntityExist() ? "Unfollow" : "follow", for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func checkIfEntityExist() -> Bool{
       
            guard let title = mangaDetail?.title, let checkIfEntityExist = coreDataManager?.someEntityIsEmpty(tilte: title) else { return false}
            return checkIfEntityExist
        
    }
    
    private func setButtonTilte(){
        addButton.setTitle(mangaDetail?.islibraryManga == true && !checkIfEntityExist() ? "Pull" : "Add" , for: .normal)
        followButton.setTitle(mangaDetail?.islibraryManga == false && !checkIfEntityExist() ? "Unfollow" : "follow", for: .normal)
    }
    
}
