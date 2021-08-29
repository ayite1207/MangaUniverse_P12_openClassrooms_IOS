//
//  LibraryViewController.swift
//  MangaUniver
//
//  Created by ayite on 28/08/2021.
//

import UIKit

class LibraryViewController: UIViewController {
    
    //MARK: Properties
    
    var mangaLibrary : [MangaLibrary] = []
    var mangaFollow : [MangaLibrary] = []
    
    private var coreDataManager: CoreDataManager?
    
    //MARK: Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var libraryCollectionView: UICollectionView!
    @IBOutlet weak var containerCollectionView: UIView!
    @IBOutlet weak var libraryOrFollowSegment: UISegmentedControl!
    
    //MARK: Cycle life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataMangaCollection = appdelegate.coreDataMangaCollection
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)
        
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        libraryCollectionView.register(UINib(nibName: "LibraryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LibraryCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideKeyboardWhenTappedAround()
        displayLibraryManga()
        displayFollowManga()
        libraryCollectionView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        let cancelButton = searchBar.value(forKey: "cancelButton") as! UIButton
        cancelButton.isEnabled = true
    }
    
    @IBAction func changeItem(_ sender: Any) {
        let index = libraryOrFollowSegment.selectedSegmentIndex == 1 ? 1 : 0
        libraryCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        libraryOrFollowSegment.selectedSegmentIndex = Int(pageNumber)
    }
    
    private func displayLibraryManga(){
        mangaLibrary = []
        if let mangaCollection = coreDataManager?.mangaCollection {
            mangaCollection.forEach({ (manga) in
                let title = manga.title ?? "error title"
                let image = manga.image
                let id = manga.id
                let synopsis = manga.synopsis ?? "error synopsis"
                let type = manga.type ?? "error type"
                let publishingStart = manga.publishingStart ?? "error publishingStart"
                let score = manga.score
                let volumes = manga.volumes
                
                let manga = MangaLibrary(image: image, title: title, synopsis: synopsis, volumes: volumes, id: id, publishingStart: publishingStart, score: score, type: type)
                mangaLibrary.append(manga)
                })
        }
        libraryCollectionView.reloadData()
    }
    
    private func displayFollowManga(){
        mangaFollow = []
        if let mangaCollection = coreDataManager?.mangaFollow {
            mangaCollection.forEach({ (manga) in
                let title = manga.title ?? "error title"
                let image = manga.image
                let id = manga.id
                let synopsis = manga.synopsis ?? "error synopsis"
                let type = manga.type ?? "error type"
                let publishingStart = manga.publishingStart ?? "error publishingStart"
                let score = manga.score
                let volumes = manga.volumes
                
                let manga = MangaLibrary(image: image, title: title, synopsis: synopsis, volumes: volumes, id: id, publishingStart: publishingStart, score: score, type: type)
                mangaFollow.append(manga)
                })
        }
        libraryCollectionView.reloadData()
    }
    
}

extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        libraryCollectionView.frame = containerCollectionView.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as? LibraryCollectionViewCell else { return UICollectionViewCell() }
            cell.mangaLibrary = mangaLibrary
            cell.onDidSelectItem = {(indexPath) in
                let mangaDetailViewControler = MangaDetailTableViewController()
                mangaDetailViewControler.mangaDetail = self.mangaLibrary[indexPath.row]
                self.show(mangaDetailViewControler, sender: nil)
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as? LibraryCollectionViewCell else { return UICollectionViewCell() }
            cell.mangaLibrary = mangaFollow
            cell.onDidSelectItem = {(indexPath) in
                let mangaDetailViewControler = MangaDetailTableViewController()
                mangaDetailViewControler.mangaDetail = self.mangaFollow[indexPath.row]
                self.show(mangaDetailViewControler, sender: nil)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension LibraryViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("bim searchText", searchText)
        var mangaFilter : [MangaLibrary] = []
        if !searchText.isBlank {
            switch  libraryOrFollowSegment.selectedSegmentIndex {
            case 0:
                mangaFilter = mangaLibrary.filter({ $0.title.contains(searchText)})
                print("bim mangaFilter / mangaLibrary", mangaFilter.count)
            case 1:
                mangaFilter = mangaFollow.filter({ $0.title.contains(searchText)})
                print("bim mangaFilter / mangaFollow", mangaFilter.count)
            default:
                print("error")
            }
        }
    }
    
}

extension LibraryViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
