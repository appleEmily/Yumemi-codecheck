//
//  HomeVCTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Emily Nozaki on 2023/02/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

class HomeVCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rpLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //cellの再利用をしない。
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    
    
}
