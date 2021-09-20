//
//  SearchViewController.swift
//  MangaUniver
//
//  Created by ayite on 20/09/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    //    MARK: - Properties
    
    let jikanService = JikanService()
    var listResultManga = [MangaLibrary]()
    var mangaToDisplay = [String: MangaLibrary]()
    var characters = [Character]()
    var charactersMangas = [String: [Character]]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var searchBar : UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search Manga"
        s.tintColor = .white
        return s
    }()
    
    // MARK: - Cycle Of Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResultManga(str: "dragon ball")
        setCollectionView()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methodes
    
    private func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId")
    }
    
    private func displayMangaDetail( mangaToDisplay: MangaLibrary? ) {
        let mangaDetailViewControler = MangaDetailTableViewController()
        mangaDetailViewControler.mangaDetail = mangaToDisplay
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
            let volumes = Double(manga.volumes )
            
            let manga = MangaLibrary(image : image.data, title: title, synopsis: synopsis,volumes : volumes, id: Double(id), publishingStart: publishingStart, score: score, type: type, islibraryManga: false, isMangaFollow: false)
            mangaLibrary.append(manga)
        })
        listResultManga = mangaLibrary
        collectionView.reloadData()
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCellId", for: indexPath)
        header.addSubview(searchBar)
        searchBar.frame = header.bounds
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listResultManga.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.categoryManga = listResultManga[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getCharactersManga(mangaToDisplay: listResultManga[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2)-5, height: (view.frame.size.width/2)*1.5-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        collectionView.reloadData()
    }
}

extension CategoryViewController {
    
    //    func hideKeyboardWhenTappedAround() {
    //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
    //        tap.cancelsTouchesInView = false
    //        view.addGestureRecognizer(tap)
    //    }
    //
    //    @objc func dismissKeyboard() {
    //        view.endEditing(true)
    //    }
}

extension SearchViewController {
    private func getResultManga(str: String){
        jikanService.getSearchResultManga(str: str) { [unowned self] result in
            switch result {
            case .success(let searchResult):
                DispatchQueue.main.async {
                    let results = searchResult.results
                    convertMyDecodableToAStruct(decodebleToConvert: results)
                    print("vfr searchResult", searchResult)
                }
            case .failure(let error):
                print("vfr error",error.description)
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
                print("error",error.description)
            }
        }
    }
}
