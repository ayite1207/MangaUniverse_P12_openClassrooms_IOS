//
//  MangaDetailTableViewController.swift
//  MangaUniver
//
//  Created by ayite on 25/07/2021.
//

import UIKit

class MangaDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var mangaDetail: MangaLibrary?
    var characters = [Character]()
    private var character : CharacterDetails?
    private var coreDataManager: CoreDataManager?
    
    // MARK: - Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = mangaDetail?.title
        setCoreData()
        setUpTableView()
    }
    
    // MARK: - Methodes
    
    private func setCoreData(){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataMangaCollection = appdelegate.coreDataMangaCollection
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)
    }
    
    private func createMangaCollection(_ mangaDetail: MangaLibrary, isFollowManga: Bool, isLibraryManga: Bool, numberOfManga: Int) {
        self.coreDataManager?.createMangaCollection(image: mangaDetail.image, title: mangaDetail.title ?? "", synopsis: mangaDetail.synopsis ?? "", volumes: Double(mangaDetail.volumes ?? 0.0), id: Double(mangaDetail.id ?? 0.0 ), publishingStart: mangaDetail.publishingStart ?? "" , score: Double(mangaDetail.score ?? 0.0 ), type: mangaDetail.type ?? "", isFollowManga: isFollowManga, isLibraryManga: isLibraryManga, numberOfManga: Double(numberOfManga))
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
        tableView.register(UINib(nibName: "DetailTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTitleTableViewCell")
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTableViewCell")
    }
    
    private func displayLibraryManga(manga: MangaCollection?) -> MangaLibrary{
        guard let manga = manga else { return MangaLibrary()}
            let title = manga.title ?? "error title"
            let image = manga.image
            let id = manga.id
            let synopsis = manga.synopsis ?? "error synopsis"
            let type = manga.type ?? "error type"
            let publishingStart = manga.publishingStart ?? "error publishingStart"
            let score = manga.score
            let volumes = manga.volumes
            let islibraryManga = manga.isLibraryManga
            let isMangaFollow = manga.isFollowManga
            let number = manga.numberOfManga
            
            return MangaLibrary(image: image, title: title, synopsis: synopsis, volumes: volumes, id: id, publishingStart: publishingStart, score: score, type: type, number: Int(number), islibraryManga: islibraryManga, isMangaFollow: isMangaFollow)
    }
    
    private func updateMangaDetail() {
        let mangaSaved = self.coreDataManager?.mangaCollection.filter({ $0.title == mangaDetail?.title}).first
        if let manga = mangaSaved {
            let manga = self.displayLibraryManga(manga: manga)
            self.mangaDetail = manga
        } else {
            self.mangaDetail?.islibraryManga = false
            self.mangaDetail?.isMangaFollow = false
        }
        self.tableView.reloadData()
    }
    
    private func alertSaveManga(_ mangaDetail: MangaLibrary, isSavingManga: Bool) {
        let titleAlertController = isSavingManga ? "Add \(mangaDetail.title ?? "")" : "Update \(mangaDetail.title ?? "") "
        let titleAlertAction = isSavingManga ? "Add" : "Update"
        let messageSuccesAlertAction = isSavingManga ? "added" : "Updated"
        
        let alertController = UIAlertController(title: titleAlertController, message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Manga"
        }
        let addAction = UIAlertAction(title: titleAlertAction, style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            guard let textStr = textField.text else {return}
            if !textStr.isBlank && Double(textStr) ?? 0.0 > 0 {
                
                if isSavingManga {
                    self.createMangaCollection(mangaDetail, isFollowManga: false, isLibraryManga: true, numberOfManga: Int(textStr) ?? 0)
                } else {
                    self.coreDataManager?.updateEntity(title: mangaDetail.title ?? "", updateIsLibraryMangaEntity: true, value: true, numberOfVolums: Double(textStr) ?? 0.0)
                }
                let alertController = UIAlertController(title: "Success", message: "Your manga \(mangaDetail.title ?? "") has been succesfully \(messageSuccesAlertAction) !", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.updateMangaDetail()
                self.present(alertController, animated: true)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Please enter a number !", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as? PhotoTableViewCell else { return UITableViewCell()}
            if character != nil {
                cell.character = character
            }  else {
                cell.detailManga = mangaDetail
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleTableViewCell") as? DetailTitleTableViewCell else { return UITableViewCell()}
            if character != nil {
                cell.character = character
            }  else {
                cell.mangaDetail = mangaDetail
                cell.characters = characters
                cell.onDidSelectItem = {(mangaDetail, isLibrary, value) in
                    if self.checkIfEntityNoExist() {
                        if isLibrary {
                            self.alertSaveManga(mangaDetail, isSavingManga: true)
                        } else {
                            self.createMangaCollection(mangaDetail, isFollowManga: true, isLibraryManga: false, numberOfManga: 0)
                        }
                    } else {
                        let manga = self.coreDataManager?.mangaCollection.filter({ $0.title == mangaDetail.title }).first
                        if isLibrary {
                            if value != true {
                                let alertController = UIAlertController(title: "What do you want to do", message: "", preferredStyle: .alert)
                                
                                let alertDelete =  UIAlertAction(title: "Delete from your library", style: .default) { action in
                                    if manga?.isFollowManga == false && value == false {
                                        self.coreDataManager?.deleteMangaCollection(title: mangaDetail.title ?? "")
                                        self.updateMangaDetail()
                                    } else {
                                        self.coreDataManager?.updateEntity(title: manga?.title ?? "", updateIsLibraryMangaEntity: true, value: false, numberOfVolums: nil)
                                    }
                                    self.updateMangaDetail()
                                }
                                let alertUpdate =  UIAlertAction(title: "Update your manga", style: .default) { action in
                                    self.alertSaveManga(mangaDetail, isSavingManga: false)
                                }
                                
                                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                                alertController.addAction(alertDelete)
                                alertController.addAction(alertUpdate)
                                alertController.addAction(cancelAction)
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                self.alertSaveManga(mangaDetail, isSavingManga: false)
                            }
                            //                        }
                        } else {
                            if manga?.isLibraryManga == false && value == false {
                                self.coreDataManager?.deleteMangaCollection(title: mangaDetail.title ?? "" )
                                self.updateMangaDetail()
                            } else {
                                self.coreDataManager?.updateEntity(title: manga?.title ?? "", updateIsLibraryMangaEntity: false, value: value, numberOfVolums: nil)
                            }
                        }
                    }
                    self.updateMangaDetail()
                }
                cell.onDidSelectCharacterItem = { (character) in
                    let characterDetailVC = MangaDetailTableViewController()
                    characterDetailVC.character = character
                    self.present(characterDetailVC, animated: true, completion: nil)
                }
            }
            
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as? InfoTableViewCell else { return UITableViewCell()}
            if character != nil {
                cell.character = character
            } else {
                cell.mangaDetail = mangaDetail
                cell.selectionStyle = .none
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let height = view.frame.size.width
            return CGFloat(height)
        }
         return UITableView.automaticDimension
    }
    
    private func checkIfEntityNoExist() -> Bool{
        guard let title = mangaDetail?.title, let checkIfEntityExist = coreDataManager?.entityExist(title: title) else { return false}
        return checkIfEntityExist
    }
    
}

extension MangaDetailTableViewController {
    @objc func deleteCell(){
        dismiss(animated: true, completion: nil)
    }
}


