//
//  CategoryViewController.swift
//  MangaUniver
//
//  Created by ayite on 26/08/2021.
//

import UIKit

class CategoryViewController: UIViewController {

    let jikanService = JikanService()
    var listeTopManga = [TopManga]()
    var listCategoryManga = [MangaLibrary]()
    var mangaToDisplay = [String: MangaLibrary]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }

}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listeTopManga.count > 0 ? listeTopManga.count : listCategoryManga.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        if listeTopManga.count > 0 {
            cell.manga = listeTopManga[indexPath.row]
        }else {
            cell.categoryManga = listCategoryManga[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listeTopManga.count > 0 {
            if let mangaToDisplay = mangaToDisplay[listeTopManga[indexPath.row].title] {
                displayMangaDetail( mangaToDisplay: mangaToDisplay )
            } else {
                getTopMangaDetail(id: String(listeTopManga[indexPath.row].id))
            }
        }else {
            displayMangaDetail( mangaToDisplay: listCategoryManga[indexPath.row] )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2)-5, height: (view.frame.size.width/2)-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
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
