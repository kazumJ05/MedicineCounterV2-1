//
//  Information2TableViewCell.swift
//  MedicineCounterV2
//
//  Created by 大原一倫 on 2019/07/21.
//  Copyright © 2019 oharakazumasa. All rights reserved.
//

import UIKit

class Information2TableViewCell: UITableViewCell {
    
    @IBOutlet var medicineLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var suuryouLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
