//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var strsLbl: UILabel!
    @IBOutlet weak var wchsLbl: UILabel!
    @IBOutlet weak var forksLbl: UILabel!
    @IBOutlet weak var issuesLbl: UILabel!
    
    
    //直す
    var homeVC: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = homeVC.repo[homeVC.idx]
        
        titleLbl.text = repo["full_name"] as? String
        langLbl.text = "Written in \(repo["language"] as? String ?? "")"
        strsLbl.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        wchsLbl.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksLbl.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLbl.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
        
    }
    
    func getImage() {
        
        let repo = homeVC.repo[homeVC.idx]
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.imgView.image = img
                    }
                }.resume()
            }
        }
        
    }
    
}
