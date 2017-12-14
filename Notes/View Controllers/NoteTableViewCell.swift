//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by LongLH on 12/12/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    static let reuseIdentifier = "NoteTableViewCell"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentesLabel: UILabel!
    @IBOutlet var updateAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
