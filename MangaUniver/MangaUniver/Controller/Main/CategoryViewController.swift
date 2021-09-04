//
//  CategoryViewController.swift
//  MangaUniver
//
//  Created by ayite on 26/08/2021.
//

import UIKit

class CategoryViewController: UIViewController {
    
// MARK: - Properties
    
    let jikanService = JikanService()
    var listeTopManga = [TopManga]()
    var listCategoryManga = [MangaLibrary]()
    var mangaToDisplay = [String: MangaLibrary]()
    var mangaFilter : [TopManga] = []
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var searchBar : UISearchBar = {
        let s = UISearchBar()
            s.placeholder = "Search Manga"
            s.delegate = self
            s.tintColor = .white
        return s
    }()
    
    // MARK: - Cycle Of Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId")

        view.addSubview(collectionView)
        
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methodes
    
    private func getTopMangaDetail(id: String){
        jikanService.getMangaTopPopularityDetail(idOfTheManga: id) { [unowned self] result in
            switch result {
            case .success(let mangaDetail):
                mangaToDisplay[mangaDetail.title ?? ""] = convertTopMangaToAStruct(topMangaToConvert: mangaDetail)
                self.displayMangaDetail(mangaToDisplay: mangaToDisplay[mangaDetail.title ?? ""])
            case .failure(let error):
                print("error",error.description)
            }
        }
    }
    
    func convertTopMangaToAStruct(topMangaToConvert: MangaTopDetail)-> MangaLibrary{
        
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
        self.show(mangaDetailViewControler, sender: nil)
    }

}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return mangaFilter.count == 0 ? listeTopManga.count > 0 ? listeTopManga.count : listCategoryManga.count : mangaFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        if mangaFilter.count == 0 {
            if listeTopManga.count > 0 {
                cell.manga = listeTopManga[indexPath.row]
            }else {
                cell.categoryManga = listCategoryManga[indexPath.row]
            }
        } else {
            cell.manga = mangaFilter[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mangaFilter.count == 0 {
            if listeTopManga.count > 0 {
                if let mangaToDisplay = mangaToDisplay[listeTopManga[indexPath.row].title] {
                    displayMangaDetail( mangaToDisplay: mangaToDisplay )
                } else {
                    getTopMangaDetail(id: String(listeTopManga[indexPath.row].id))
                }
            }else {
                displayMangaDetail( mangaToDisplay: listCategoryManga[indexPath.row] )
            }
        } else {
            if let mangaToDisplay = mangaToDisplay[mangaFilter[indexPath.row].title] {
                displayMangaDetail( mangaToDisplay: mangaToDisplay )
            } else {
                getTopMangaDetail(id: String(mangaFilter[indexPath.row].id))
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2)-5, height: (view.frame.size.width/2)-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("bim searchText", searchText)
        mangaFilter = []
        if !searchText.isBlank {
            mangaFilter = listeTopManga.filter({ $0.title.lowercased().contains(searchText.lowercased())})
        }
        collectionView.reloadData()
    }
}

extension CategoryViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
