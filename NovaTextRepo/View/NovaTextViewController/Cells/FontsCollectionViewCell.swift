//
//  FontsCollectionViewCell.swift
//  NovaTextRepo
//
//  Created by MBA0217 on 5/11/21.
//

import UIKit

class FontsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textLabel.text = "This is\n NovaText\n Project"
    }
    
    override func prepareForReuse() {
        self.layer.borderColor = UIColor.black.cgColor
        textLabel.textColor = .black
    }
    
    func updateUI(font: UIFont, isSelecting: Bool) {
        textLabel.font = font
        textLabel.textColor = isSelecting ? .red : .black
        self.layer.borderColor = isSelecting ? UIColor.red.cgColor :  UIColor.black.cgColor
    }

}
