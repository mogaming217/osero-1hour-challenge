//
//  OseroCell.swift
//  osero-1hour-challenge
//
//  Created by Seiya Mogami on 2019/02/10.
//  Copyright © 2019 mogaming. All rights reserved.
//

import UIKit

class OseroCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = ""
    }
}
