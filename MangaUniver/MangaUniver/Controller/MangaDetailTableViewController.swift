//
//  MangaDetailTableViewController.swift
//  MangaUniver
//
//  Created by ayite on 25/07/2021.
//

import UIKit

protocol SetTitleButtonDelegateProtocol {
    func changeTitleButton(myData: Bool)
}

class MangaDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var mangaDetail: MangaLibrary?
    var delegate : SetTitleButtonDelegateProtocol?
    
    private var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataMangaCollection = appdelegate.coreDataMangaCollection
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)
        
        tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
        tableView.register(UINib(nibName: "DetailTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTitleTableViewCell")
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTableViewCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as? PhotoTableViewCell else { return UITableViewCell()}
            cell.detailManga = mangaDetail
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleTableViewCell") as? DetailTitleTableViewCell else { return UITableViewCell()}
            cell.mangaDetail = mangaDetail
            cell.onDidSelectItem = {(mangaDetail, isLibrary) in
                if self.checkIfEntityExist() {
                    if isLibrary {
                        let alertController = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
                        alertController.addTextField { (textField : UITextField) in
                            textField.placeholder = "Task"
                        }
                        let addAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
                            let textField = alertController.textFields![0] as UITextField
                            guard let textStr = textField.text else {return}
                            
                            if !textStr.isBlank && Double(textStr) ?? 0.0 > 0 {
                                self.coreDataManager?.createMangaCollection(image: mangaDetail.image, title: mangaDetail.title, synopsis: mangaDetail.synopsis, volumes: Double(mangaDetail.volumes ?? 0), id: Double(mangaDetail.id ), publishingStart: mangaDetail.publishingStart , score: Double(mangaDetail.score ), type: mangaDetail.type, isLibraryManga: isLibrary, numberOfManga: Double(textStr) ?? 0.0)
                          
                                let alertController = UIAlertController(title: "Success", message: "Your manga \(mangaDetail.title) has been succesfully added !", preferredStyle: .alert)
                                       alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.delegate?.changeTitleButton(myData: true)
                                self.present(alertController, animated: true)
                            } else {
                                let alertController = UIAlertController(title: "Error", message: "Please enter a number !", preferredStyle: .alert)
                                       alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alertController, animated: true)
                            }
                        })
                        
                        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        
                        alertController.addAction(CancelAction)
                        alertController.addAction(addAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.coreDataManager?.createMangaCollection(image: mangaDetail.image, title: mangaDetail.title, synopsis: mangaDetail.synopsis, volumes: Double(mangaDetail.volumes ?? 0), id: Double(mangaDetail.id ), publishingStart: mangaDetail.publishingStart , score: Double(mangaDetail.score ), type: mangaDetail.type, isLibraryManga: isLibrary, numberOfManga: 0)
                    }
                    
                    
                    
                } else {
                    self.coreDataManager?.deleteMangaCollection(title: mangaDetail.title )
                }
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as? InfoTableViewCell else { return UITableViewCell()}
            cell.mangaDetail = mangaDetail
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let height = view.frame.size.width
            return CGFloat(height)
        case 1:
            return 100
            
        default:
            return 600
        }
        
    }
    
    private func checkIfEntityExist() -> Bool{
        guard let title = mangaDetail?.title, let checkIfEntityExist = coreDataManager?.someEntityExists(tilte: title) else { return false}
        return checkIfEntityExist
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MangaDetailTableViewController {
    @objc func deleteCell(){
        dismiss(animated: true, completion: nil)
    }
}
