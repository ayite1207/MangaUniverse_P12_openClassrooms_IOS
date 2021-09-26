//
//  TitleTableViewCell.swift
//  MangaUniver
//
//  Created by ayite on 07/07/2021.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var onDidSelectHeader: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        titleLabel.font = UIFont(descriptor: UIFontDescriptor(name: "AgentOrange", size: 12), size: 12)
        // Initialization code
    }

    @IBAction func displayCategory(_ sender: Any) {
        self.onDidSelectHeader?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
