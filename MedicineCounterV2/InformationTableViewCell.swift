//
//  InformationTableViewCell.swift
//  MedicineCounterV2
//
//  Created by 大原一倫 on 2019/07/21.
//  Copyright © 2019 oharakazumasa. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {
    
    @IBOutlet var medicineLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var suuryouLabel: UILabel!
    @IBOutlet var nissuuLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var notifiTiLabel: UILabel!
    @IBOutlet var notifiLabel: UILabel!
    @IBOutlet var notifiHidLabel: UILabel!
    
    var number1:Int = 0
    let saveData = UserDefaults.standard
    var medicine : [Dictionary<String, String>] = []
    var medicine1: [Dictionary<String, String>] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
