//
//  TableViewCell.swift
//  TeamProject
//
//  Created by 황재현 on 08/08/2019.
//  Copyright © 2019 jo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContents: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblInterval: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
