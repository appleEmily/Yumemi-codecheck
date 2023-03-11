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
    weak var task: URLSessionTask?
    var accessUrl: String!
    var enterdWord: String!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //srchBrの設定
        srchBr.placeholder = "GitHubのリポジトリを検索できるよー"
        srchBr.autocapitalizationType = .none
        srchBr.delegate = self
        
        //tableViewの話
        tableView.register(UINib(nibName: "HomeVCTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //タスクをキャンセル。
        // task?.cancel()
        if searchText.isEmpty {
            //検索して出ていたのを全部消す
            enterdWord = nil
            task?.cancel()
            searchApi()
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        enterdWord = searchBar.text!
        searchApi()
    }
    
    //APIを叩くメソッド
    func searchApi() {
        
        if let enterdWord {
            accessUrl = "https://api.github.com/search/repositories?q=\(enterdWord)"
            //パーセントエンコードで全文字に対応させる。
            let encodedUrl: String = accessUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            task = URLSession.shared.dataTask(with: URL(string: encodedUrl)!) {[weak self] (data, res, err) in
                URLSession.shared.finishTasksAndInvalidate()
                
                let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any]
                
                if let numberOfItem: Int =  obj!["total_count"] as? Int {
                    
                    if numberOfItem != 0 {
                        let items = obj!["items"] as? [[String: Any]]
                        self?.repo = items!
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            
                        }
                    } else {
                        //存在しないリポジトリの時、アラートを表示する
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "存在しないリポジトリです😭", message: "検索し直してください。", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                
            }
            task?.resume()
        } else {
            print("nothing")
            repo.removeAll()
            self.tableView.reloadData()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! HomeVCTableViewCell
        let rp = repo[indexPath.row]
        cell.rpLabel.text = rp["full_name"] as? String ?? ""
        cell.langLabel.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "goToDetail", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    
}

