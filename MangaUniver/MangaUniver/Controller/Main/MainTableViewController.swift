//
//  MainTableViewController.swift
//  MangaUniver
//
//  Created by ayite on 05/07/2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let jikanService = JikanService()
    var mangaTopPopularity : MangaTopPopularity?
    var categoryDisplay = [String: [MangaLibrary]]()
    var topMangaToDisplay = [String: MangaLibrary]()
    var listeStructTopManga = [TopManga]()
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        
        let samouraiMangaRequestConstructor = RequestMangaConstructor.samouraiManga
        let parodyMangaRequestConstructor = RequestMangaConstructor.parodyManga
        let psychologicalMangaRequestConstructor = RequestMangaConstructor.psychologicalManga
        
        getMangaCategory(requestConstructor: nil)
        getMangaCategory(requestConstructor: samouraiMangaRequestConstructor)
        getMangaCategory(requestConstructor: parodyMangaRequestConstructor)
        getMangaCategory(requestConstructor: psychologicalMangaRequestConstructor)
        
        dispatchGroup.notify(queue: .main){
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as? TitleTableViewCell else { return UITableViewCell()}
        cell.titleLabel.font = cell.titleLabel.font.withSize(30)
        var title = ""
        switch section {
        case 0:
            title = "Les plus populaires"
            cell.onDidSelectHeader = {() in
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let categoryViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                categoryViewController.listeTopManga = self.listeStructTopManga
                self.navigationController?.pushViewController(categoryViewController, animated: true)
            }
        case 1:
            title = "Top Samourai Manga"
            guard let mangaArray = categoryDisplay["samouraiManga"] else { return UIView() }
            cell.onDidSelectHeader = {() in
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let categoryViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                categoryViewController.listCategoryManga = mangaArray
                self.navigationController?.pushViewController(categoryViewController, animated: true)
            }
        case 2:
            title = "Top Parody Manga"
            guard let mangaArray = categoryDisplay["parodyManga"] else { return UIView() }
            cell.onDidSelectHeader = {() in
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let categoryViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                categoryViewController.listCategoryManga = mangaArray
                self.navigationController?.pushViewController(categoryViewController, animated: true)
            }        case 3:
                title = "Top Psychological Manga"
                guard let mangaArray = categoryDisplay["psychologicalManga"] else { return UIView() }
                cell.onDidSelectHeader = {() in
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let categoryViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                    categoryViewController.listCategoryManga = mangaArray
                    self.navigationController?.pushViewController(categoryViewController, animated: true)
                }
        default:
            break
        }
        cell.titleLabel.text = title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categoryDisplay.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
            cell.mangaTopPopularity = self.mangaTopPopularity
            cell.onDidSelectItem = {(indexPath) in
                if self.topMangaToDisplay[self.mangaTopPopularity?.top[indexPath.row].title ?? ""] != nil {
                    self.displayMangaDetail( mangaToDisplay: self.topMangaToDisplay[self.mangaTopPopularity?.top[indexPath.row].title ?? ""])
                } else {
                    guard let mangaId = self.mangaTopPopularity?.top[indexPath.row].malID else { return }
                    self.getTopMangaDetail(id: String(mangaId))
                }
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
            guard let mangaSamurai = categoryDisplay["samouraiManga"] else { return UITableViewCell() }
            cell.listGenreManga = mangaSamurai
            cell.onDidSelectItem = {(indexPath) in
                self.displayMangaDetail( mangaToDisplay: mangaSamurai[indexPath.row])
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
            guard let parodyManga = categoryDisplay["parodyManga"] else { return UITableViewCell() }
            cell.listGenreManga = parodyManga
            cell.onDidSelectItem = {(indexPath) in
                self.displayMangaDetail(mangaToDisplay: parodyManga[indexPath.row])
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
            guard let psychologicalManga = categoryDisplay["psychologicalManga"] else { return UITableViewCell() }
            cell.listGenreManga = psychologicalManga
            cell.onDidSelectItem = {(indexPath) in
                self.displayMangaDetail(mangaToDisplay: psychologicalManga[indexPath.row])
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 0
        if indexPath.section == 0 {
            height = Int(view.frame.size.width)
        } else {
            height = 200
        }
        return CGFloat(height)
    }
    
    
    private func displayMangaDetail( mangaToDisplay: MangaLibrary? = nil ) {
        let mangaDetailViewControler = MangaDetailTableViewController()
        mangaDetailViewControler.mangaDetail = mangaToDisplay
        self.show(mangaDetailViewControler, sender: nil)
    }
    
}

extension MainTableViewController {
    
    private func getTopMangaDetail(id: String){
        jikanService.getMangaTopPopularityDetail(idOfTheManga: id) { [unowned self] result in
            switch result {
            case .success(let mangaDetail):
                topMangaToDisplay[mangaDetail.title ?? ""] = convertTopMangaToAStruct(topMangaToConvert: mangaDetail)
                self.displayMangaDetail(mangaToDisplay: topMangaToDisplay[mangaDetail.title ?? ""])
            case .failure(let error):
                print("error",error.description)
            }
        }
    }
    
    private func getMangaCategory(requestConstructor: RequestMangaConstructor?){
        dispatchGroup.enter()
        if let requestConstructor = requestConstructor {
            jikanService.getGenreManga(category: requestConstructor.mangaNumber, path: requestConstructor.path) { [unowned self] result in
                switch result {
                case .success(let listMangaCategory):
                    self.categoryDisplay[requestConstructor.mangaCategory] = convertMyDecodableToAStruct(decodebleToConvert: listMangaCategory)
                    dispatchGroup.leave()
                case .failure(let error):
                    print("error",error.description)
                }
            }
        } else {
            jikanService.getMangaTopPopularity() { [unowned self] result in
                switch result {
                case .success(let listTopManga):
                    self.mangaTopPopularity = listTopManga
                    self.listeStructTopManga = convertTopMangaToArrayStruct(listTopManga: listTopManga)
                    dispatchGroup.leave()
                case .failure(let error):
                    print(error.description)
                }
            }
            
        }
    }
    
    func convertMyDecodableToAStruct(decodebleToConvert: ListCategoryManga)-> [MangaLibrary]{
        var mangaLibrary : [MangaLibrary] = []
        decodebleToConvert.manga.forEach({ (manga) in
            let title = manga.title
            let image = manga.imageUrl
            let id = manga.malId
            let synopsis = manga.synopsis
            let type = manga.type
            let publishingStart = manga.publishingStart ?? "error publishingStart"
            let score = manga.score ?? 0.0
            let volumes = Double(manga.volumes ?? 0)
            
            let manga = MangaLibrary(image: image.data, title: title, synopsis: synopsis, volumes: volumes, id: Double(id), publishingStart: publishingStart, score: score, type: type)
            mangaLibrary.append(manga)
        })
        return mangaLibrary
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
    
    func convertTopMangaToArrayStruct(listTopManga: MangaTopPopularity)-> [TopManga]{
        var mangaLibrary : [TopManga] = []
        listTopManga.top.forEach({ (manga) in
            let title = manga.title
            let image = manga.imageURL
            let id = manga.malID
            
            let manga = TopManga(image: image.data, title: title,id: id)
            mangaLibrary.append(manga)
        })
        return mangaLibrary
    }
}
