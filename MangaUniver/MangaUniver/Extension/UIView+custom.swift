//
//  UIView+custom.swift
//  MangaUniver
//
//  Created by ayite on 22/08/2021.
//

import Foundation
import UIKit


extension UIView {
    
    //MARK: - Methode
    
    func raduis(view: UIView, raduis: CGFloat){
        view.layer.cornerRadius = raduis
        view.layer.masksToBounds = true
    }
    
    func border(view: UIView, color: CGColor){
        view.layer.borderWidth = 1
        view.layer.borderColor = color
    }
}
