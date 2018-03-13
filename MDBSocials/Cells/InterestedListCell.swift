//
//  InterestedListCell.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 3/3/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class InterestedListCell: UITableViewCell {
    
    var profilePic: UIImageView!
    var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        
        profilePic = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.height, height: contentView.frame.height))
        contentView.addSubview(profilePic)
        
        name = UILabel(frame: CGRect(x: contentView.frame.height, y: contentView.frame.height / 2 - 10, width: contentView.frame.width - contentView.frame.height, height: 20))
        name.textAlignment = .center
        name.font = UIFont(name: "HelveticaNeue-Light", size: 19)
        contentView.addSubview(name)
        
        
        
    }


}
