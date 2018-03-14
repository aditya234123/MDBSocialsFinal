//
//  InterestedListView.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 3/3/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class InterestedListView: UIView {
    
    var tableView: UITableView!
    var postID: String?
    var names = [String]()
    var nameToID = [String : String]()
    var nameids = [String]()

    init(frame: CGRect, id: String) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        postID = id
        fetchInterested()
        self.backgroundColor = .white
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        tableView.register(InterestedListCell.self, forCellReuseIdentifier: "Interestedcell")
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
    }

    func fetchInterested() {
        FirebaseAPIClient.fetchInterested(postID: self.postID!, names: true).then { (arr) in
            self.names = arr
        }.then {
            FirebaseAPIClient.fetchInterested(postID: self.postID!, names: false)
        }.then { arr -> Void in
            self.nameids = arr
        }.then {
            self.tableView.reloadData()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InterestedListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Interestedcell") as! InterestedListCell

        for var x: UIView in cell.contentView.subviews {
            x.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        cell.name.text = names[indexPath.row]
        
        StorageHelper.getProfilePic(id: nameids[indexPath.row]).then { (image) in
            DispatchQueue.main.async {
                cell.profilePic.image  = image
                cell.setNeedsLayout()
            }
        }
        
        return cell
    }
}
