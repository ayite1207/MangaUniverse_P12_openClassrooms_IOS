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
    
    let jikanService = JikanService()
    var isLibraryManga = false
    var isFollowManga = false
    var character : CharacterDetails? {
        didSet{
            detailTitleManga.text = character?.name
            charactersCollectionView.isHidden = true
            addButton.isHidden = true
            followButton.isHidden = true
        }
        
    }
    
    var mangaDetail: MangaLibrary? {
        didSet {
            detailTitleManga.text = mangaDetail?.title
            setButtonTilte()
        }
    }
    
    var characters : [Character]? {
        didSet {
            charactersCollectionView.reloadData()
        }
    }
    
    private var coreDataManager: CoreDataManager?
    
    var onDidSelectItem: ((_ manga: MangaLibrary, _ isLibrary: Bool, _ value: Bool) -> ())?
    var onDidSelectCharacterItem: ((_ manga: CharacterDetails) -> ())?
    var delegate: GetCharacterDetails?
    
    //MARK: - Outlets
    
    @IBOutlet weak var detailTitleManga: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataMangaCollection = appdelegate.coreDataMangaCollection
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)
        
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        charactersCollectionView.register(UINib(nibName: "CharactersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharactersCollectionViewCell")
        
        setButton()
        
    }
    
    //MARK: - Action
    
    @IBAction func addManga(_ sender: Any) {
        guard let mangaToSave = mangaDetail else { return }
        self.onDidSelectItem?(mangaToSave, true, !isLibraryManga)
        setButtonTilte()
    }
    
    
    @IBAction func followManga(_ sender: Any) {
        setButtonTilte()
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
            UIView.animate(withDuration: 1) {
                self.followButton.backgroundColor = manga.isFollowManga == true  ? .green : .white
                self.followButton.tintColor = manga.isFollowManga == true  ? .white : .green
            }
            isLibraryManga = manga.isLibraryManga
            followButton.setTitle(manga.isFollowManga == true  ? "Unfollow" : "follow", for: .normal)
            isFollowManga = manga.isFollowManga
        } else {
            addButton.setTitle( "Add" , for: .normal)
            followButton.setTitle( "follow", for: .normal)
        }
        
    }
    
}

extension  DetailTitleTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem = characters?.count ?? 0 < 10 ? characters?.count : 10
        return numberOfItem ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let charactersCell = charactersCollectionView.dequeueReusableCell(withReuseIdentifier: "CharactersCollectionViewCell", for: indexPath) as? CharactersCollectionViewCell else { return UICollectionViewCell() }
        charactersCell.character = characters?[indexPath.row]
        return charactersCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let idCharacter = characters?[indexPath.row].malID else { return }
        getCharacterDetails(id: String(idCharacter))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.height - 10) , height: (collectionView.bounds.size.height))
    }
    
}

extension DetailTitleTableViewCell {
    
    private func getCharacterDetails(id: String){
        jikanService.getCharacterDetailManga(idOfTheCharacter: id) { [unowned self] result in
            switch result {
            case .success(let characterDetail):
                print("vfr charcterDetail", characterDetail.name)
                self.onDidSelectCharacterItem?(characterDetail)
            case .failure(let error):
                print("error",error.description)
            }
        }
    }
    
}
