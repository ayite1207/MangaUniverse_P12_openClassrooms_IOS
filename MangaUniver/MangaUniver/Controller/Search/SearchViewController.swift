//
//  SearchViewController.swift
//  MangaUniver
//
//  Created by ayite on 20/09/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    //    MARK: - Properties
    
    private var jikanService = JikanService()
    private var listResultManga = [MangaLibrary]()
    private var mangaToDisplay = [String: MangaLibrary]()
    private var characters = [Character]()
    private var charactersMangas = [String: [Character]]()
    private var coreDataManager: CoreDataManager?
    
    //    MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Cycle Of Life
    
    override func viewDidLoad() {
        searchBar.delegate = self
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        setCoreData()
        hideKeyboardWhenTappedAround()
        setCollectionView()
    }
    
    // MARK: - Methodes
    
    private func setCoreData(){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataMangaCollection = appdelegate.coreDataMangaCollection
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)
    }
    
    private func setCollectionView() {
        activityIndicator.isHidden = true
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
        resultCollectionView.backgroundColor = .white
        
        resultCollectionView.register(UINib(nibName: "EmptyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmptyCollectionViewCell")
        
        resultCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        resultCollectionView.collectionViewLayout = layout
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
    
    private func displayMangaDetail( mangaToDisplay: MangaLibrary? ) {
        let mangaDetailViewControler = MangaDetailTableViewController()
        let mangaSaved = coreDataManager?.mangaCollection.filter({ $0.title == mangaToDisplay?.title}).first
        
        if let manga = mangaSaved {
            let manga = displayLibraryManga(manga: manga)
            mangaDetailViewControler.mangaDetail = manga
        } else {
            mangaDetailViewControler.mangaDetail = mangaToDisplay
        }
        mangaDetailViewControler.characters = characters
        self.show(mangaDetailViewControler, sender: nil)
    }
    
    func convertMyDecodableToAStruct(decodebleToConvert: [Results]){
        var mangaLibrary : [MangaLibrary] = []
        decodebleToConvert.forEach({ (manga) in
            let title = manga.title
            let image = manga.imageURL
            let id = manga.malID
            let synopsis = manga.synopsis
            let type = manga.type
            let publishingStart = manga.startDate
            let score = manga.score
            let volumes = Double(manga.volumes ?? 00 )
            
            let manga = MangaLibrary(image : image?.data, title: title, synopsis: synopsis,volumes : volumes, id: Double(id ?? 0), publishingStart: publishingStart, score: score, type: type, islibraryManga: false, isMangaFollow: false)
            mangaLibrary.append(manga)
        })
        listResultManga = mangaLibrary
        resultCollectionView.reloadData()
    }
    
}

// MARK: - CollectionView

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        resultCollectionView.frame = containerView.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listResultManga.count == 0 ? 1 : listResultManga.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if listResultManga.count == 0 {
            guard let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as? EmptyCollectionViewCell else { return UICollectionViewCell() }
            cell = emptyCell
            //            cell.titleMangaLabel.text = "It s time to search 8"
        } else {
            guard let resultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            resultCell.categoryManga = listResultManga[indexPath.row]
            cell = resultCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listResultManga.count > 0 {
            getCharactersManga(mangaToDisplay: listResultManga[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size : CGSize
        if listResultManga.count == 0 {
            size = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        } else {
            size = CGSize(width: (view.frame.size.width/2)-10, height: (view.frame.size.width/2)*1.5-5)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar){
        guard let text = searchBar.text else { return }
        if !text.isBlank {
            if text.count <  3 {
                showAlertError(with: "Please enter 3 letters")
            } else {
                self.getResultManga(str: text)
            }
        } else {
            showAlertError(with: "Please enter a research")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            listResultManga = []
        }
        resultCollectionView.reloadData()
    }
}

extension SearchViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension SearchViewController {
    private func getResultManga(str: String){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        jikanService.getSearchResultManga(str: str) { [unowned self] result in
            switch result {
            case .success(let searchResult):
                DispatchQueue.main.async {
                    let results = searchResult.results
                    convertMyDecodableToAStruct(decodebleToConvert: results)
                    activityIndicator.isHidden = true
                    activityIndicator.stopAnimating()
                    
                }
            case .failure(let error):
                showAlertError(with: "Error : \(error.description)")
            }
        }
    }
    
    private func getCharactersManga(mangaToDisplay: MangaLibrary? = nil){
        let mangaId = String(Int(mangaToDisplay?.id ?? 0.0))
        jikanService.getCharactersManga(idOfTheManga: mangaId) { [unowned self] result in
            switch result {
            case .success(let mangaCharacters):
                self.characters = mangaCharacters.characters
                self.charactersMangas[mangaToDisplay?.title ?? ""] = mangaCharacters.characters
                displayMangaDetail( mangaToDisplay: mangaToDisplay )
            case .failure(let error):
                showAlertError(with: "Error : \(error.description)")
            }
        }
    }
}
