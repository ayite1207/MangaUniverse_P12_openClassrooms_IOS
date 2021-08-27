//
//  DetailTitleTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 06/08/2021.
//

import UIKit
import CoreData

class DetailTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailTitleManga: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var mangaCollection = "MangaCollection"
    var mangaFollow = "MangaFollow"
    
    var mangaDetail: MangaLibrary? {
        didSet {
            detailTitleManga.text = mangaDetail?.title
            changeAddAndFollowButton(entity: mangaCollection)
            changeAddAndFollowButton(entity: mangaFollow)
        }
    }
    
    var mangaLibrary : MangaLibrary?
    private var coreDataManager: CoreDataManager?

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
        if checkIfEntityExist(entity: mangaCollection) {
            coreDataManager?.createMangaCollection(image: mangaDetail?.image, title: mangaToSave.title, synopsis: mangaToSave.synopsis, volumes: Double(mangaToSave.volumes ?? 0), id: Double(mangaToSave.id ), publishingStart: mangaToSave.publishingStart , score: Double(mangaToSave.score ), type: mangaToSave.type)
        } else {
            coreDataManager?.deleteMangaCollection(title: mangaToSave.title )
        }
        changeAddAndFollowButton(entity: mangaCollection)
    }

    
    @IBAction func followManga(_ sender: Any) {
        guard let mangaToSave = mangaDetail else { return }
        if checkIfEntityExist(entity: mangaFollow) {
            coreDataManager?.createMangaFollow(image: mangaDetail?.image, title: mangaToSave.title, synopsis: mangaToSave.synopsis, volumes: Double(mangaToSave.volumes ?? 0), id: Double(mangaToSave.id ), publishingStart: mangaToSave.publishingStart , score: Double(mangaToSave.score ), type: mangaToSave.type)
        } else {
            coreDataManager?.deleteMangaFollow(title: mangaToSave.title )
        }
        changeAddAndFollowButton(entity: mangaFollow)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func checkIfEntityExist(entity: String) -> Bool{
        switch entity {
        case "MangaCollection":
            guard let title = mangaDetail?.title, let checkIfEntityExist = coreDataManager?.someEntityExists(tilte: title) else { return false}
            return checkIfEntityExist
        case "MangaFollow":
            guard let title = mangaDetail?.title, let checkIfEntityExist = coreDataManager?.someEntityExistInMangaFollow(tilte: title) else { return false}
            return checkIfEntityExist
        default:
            print("error")
        }
        return false
    }
    
    private func changeAddAndFollowButton(entity: String){
        if !checkIfEntityExist(entity: entity) {
            if entity == mangaCollection {
                addButton.setTitle("Pull", for: .normal)
            } else {
                followButton.setTitle("Unfollow", for: .normal)
            }
            
        } else {
            if entity == mangaCollection {
                addButton.setTitle("Add", for: .normal)
            } else {
                followButton.setTitle("Follow", for: .normal)
            }
            
        }
    }
    
}
