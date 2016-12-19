//
//  MonsterCell.swift
//  TeamsGamePrototype2
//
//  Created by Michael Hsiu on 12/11/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import Foundation

class MonsterCell: UITableViewCell {

    @IBOutlet var monsterPic: UIImageView!
    @IBOutlet var monsterName: UITextView!
    @IBOutlet var monsterDesc: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

