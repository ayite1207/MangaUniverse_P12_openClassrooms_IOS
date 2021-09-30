//
//  CategoryViewController.swift
//  MangaUniver
//
//  Created by ayite on 26/08/2021.
//

import UIKit

class CategoryViewController: UIViewController {
    
// MARK: - Properties
    
    var listCategoryManga = [MangaLibrary]()
    private var mangaToDisplay = [String: MangaLibrary]()
    private var mangaFilter : [MangaLibrary] = []
    private var characters = [Character]()
    private var charactersMangas = [String: [Character]]()
    var categoryTitle = ""
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // MARK: - Cycle Of Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        title = categoryTitle
        
        setCollectionView()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Methodes
    
    private func setCollectionView() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.backgroundColor = .white
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        categoryCollectionView.collectionViewLayout = layout
        categoryCollectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId")
    }
    
    private func getTopMangaDetail(id: String){
        JikanService.shared.getMangaTopPopularityDetail(idOfTheManga: id) { [unowned self] result in
            switch result {
            case .success(let mangaDetail):
                mangaToDisplay[mangaDetail.title ?? ""] = convertTopMangaToAStruct(topMangaToConvert: mangaDetail)
                self.displayMangaDetail(mangaToDisplay: mangaToDisplay[mangaDetail.title ?? ""])
            case .failure(let error):
                showAlertError(with: "Error : \(error.description)")
            }
        }
    }
    
    private func convertTopMangaToAStruct(topMangaToConvert: MangaTopDetail)-> MangaLibrary{
        
        let title = topMangaToConvert.title ?? ""
        let image = topMangaToConvert.imageurl
        let id = Double(topMangaToConvert.malid ?? 0)
        let synopsis = topMangaToConvert.synopsis ?? ""
        let type = topMangaToConvert.type ?? ""
        let publishingStart = topMangaToConvert.published?.string ?? ""
        let score = topMangaToConvert.score ?? 0
        let volumes = Double(topMangaToConvert.volumes ?? 0)
         
        let topMangaToDisplay = MangaLibrary(image : image?.data, title: title, synopsis: synopsis,volumes : volumes, id: id, publishingStart: publishingStart, score: score, type: type)
        
        return topMangaToDisplay
    }
    
    private func displayMangaDetail( mangaToDisplay: MangaLibrary? ) {
        let mangaDetailViewControler = MangaDetailTableViewController()
        mangaDetailViewControler.mangaDetail = mangaToDisplay
        mangaDetailViewControler.characters = characters
        self.show(mangaDetailViewControler, sender: nil)
    }

}

// MARK: - CollectionView

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaFilter.count == 0 ? listCategoryManga.count : mangaFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        if mangaFilter.count == 0 {
            cell.categoryManga = listCategoryManga[indexPath.row]
        } else {
            cell.categoryManga = mangaFilter[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mangaFilter.count == 0 {
                getCharactersManga(mangaToDisplay: listCategoryManga[indexPath.row])
        } else {
            if let mangaToDisplay = mangaToDisplay[mangaFilter[indexPath.row].title ?? ""] {
                getCharactersManga(mangaToDisplay: mangaToDisplay)
            } else {
                getCharactersManga(mangaToDisplay: mangaFilter[indexPath.row])

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2)-10, height: (view.frame.size.width/2)*1.5-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mangaFilter = []
        if !searchText.isBlank {
            mangaFilter = listCategoryManga.filter({ $0.title?.lowercased().contains(searchText.lowercased()) ?? false})
            searchBar.becomeFirstResponder()
        }
        categoryCollectionView.reloadData()
    }
}

extension CategoryViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}


extension CategoryViewController {
    private func getCharactersManga(mangaToDisplay: MangaLibrary? = nil){
        let mangaId = String(Int(mangaToDisplay?.id ?? 0.0))
        JikanService.shared.getCharactersManga(idOfTheManga: mangaId) { [unowned self] result in
            switch result {
            case .success(let mangaCharacters):
                self.characters = mangaCharacters.characters
                self.charactersMangas[mangaToDisplay?.title ?? ""] = mangaCharacters.characters
                if mangaToDisplay?.synopsis != nil {
                    displayMangaDetail( mangaToDisplay: mangaToDisplay )
                } else {
                    getTopMangaDetail(id: mangaId)
                }
            case .failure(let error):
                showAlertError(with: "Error : \(error.description)")
            }
        }
    }
}
