//
//  UIViewController+showAlert.swift
//  MangaUniver
//
//  Created by ayite on 26/09/2021.
//

import UIKit

extension UIViewController {
    
    //MARK: - Methodes
    
    func showAlertError(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showAlertSaving(with message: String) {
        let alertController = UIAlertController(title: "Succes", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
