//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var srchBr: UISearchBar!
    
    var repo: [[String: Any]] = []
    
    var task: URLSessionTask?
    var url: String!
    var idx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //srchBrにplaceholderをセット
        srchBr.placeholder = "GitHubのリポジトリを検索できるよー"
        srchBr.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let word = searchBar.text {
            url = "https://api.github.com/search/repositories?q=\(word)"
            task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
                if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = obj["items"] as? [[String: Any]] {
                        self.repo = items
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            task?.resume()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetail"{
            let dtlVC = segue.destination as! DetailViewController
            dtlVC.homeVC = self
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let rp = repo[indexPath.row]
        cell.textLabel?.text = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        performSegue(withIdentifier: "goToDetail", sender: self)
        
    }
    
}
