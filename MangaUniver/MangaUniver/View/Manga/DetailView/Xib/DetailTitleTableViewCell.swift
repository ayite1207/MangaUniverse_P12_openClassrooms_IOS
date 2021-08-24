//
//  DetailTitleTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 06/08/2021.
//

import UIKit

class DetailTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailTitleManga: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var mangaDetail: MangaLibrary? {
        didSet {
            detailTitleManga.text = mangaDetail?.title
            changeAddAndFollowButton()
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
        if checkIfEntityExist(tile: mangaToSave.title) {
            coreDataManager?.createMangaCollection(image: mangaDetail?.image, title: mangaToSave.title, synopsis: mangaToSave.synopsis, volumes: Double(mangaToSave.volumes ?? 0), id: Double(mangaToSave.id ), publishingStart: mangaToSave.publishingStart , score: Double(mangaToSave.score ), type: mangaToSave.type)
        } else {
            coreDataManager?.deleteMangaCollection(title: mangaToSave.title )
        }
        changeAddAndFollowButton()
    }

    
    @IBAction func followManga(_ sender: Any) {
        print("followManga")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func checkIfEntityExist(tile: String) -> Bool{
        guard let title = mangaDetail?.title, let checkIfEntityExist = coreDataManager?.someEntityExists(tilte: title) else { return false}
        return checkIfEntityExist
    }
    
    private func changeAddAndFollowButton(){
        if !checkIfEntityExist(tile: mangaDetail?.title ?? "") {
            addButton.setTitle("Retirez", for: .normal)
        } else {
            addButton.setTitle("Ajoutez", for: .normal)
        }
    }
    
}
