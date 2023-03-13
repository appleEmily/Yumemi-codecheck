//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var homeModel = HomeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBarの設定
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        
        //tableViewの話
        tableView.register(UINib(nibName: "HomeVCTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    //テキストが変更されたとき。
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //検索して出ていたのを全部消す
            //homeModel.enterdWord = nil
            homeModel.task?.cancel()
            homeModel.repo.removeAll()
            self.tableView.reloadData()
            
        }
        
    }
    
    //検索が始まるとき。
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let enterdWord = searchBar.text {
            //パーセントエンコードで全文字に対応させる。
            let encodedWnterdWord: String = enterdWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            searchApi(enterdWord: encodedWnterdWord)
        } else {
            print("nothing")
            homeModel.repo.removeAll()
            self.tableView.reloadData()
        }
    }
    
    
    
    //APIを叩くメソッド
    func searchApi(enterdWord: String) {
        
        //accessUrlを作成。
        homeModel.accessUrl = "https://api.github.com/search/repositories?q=\(enterdWord)"
        
        //taskをセット
        homeModel.task = URLSession.shared.dataTask(with: URL(string: homeModel.accessUrl)!) {[weak self] (data, res, err) in
            //dataが存在するか。
            guard let data else {
                print("received data not exist")
                return
            }
            
            //JSONにアクセスできているか。
            guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("JSON Serialization failed")
                return
            }
            
            //検索結果が0このときにアラートを出す。
            let numberOfItem: Int =  (obj["total_count"] as? Int)!
            
            switch numberOfItem {
                //存在しないリポジトリの時、アラートを表示する
            case 0:
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "存在しないリポジトリです😭", message: "検索し直してください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true, completion: nil)
                }
                //検索結果を表示
            default:
                let items = obj["items"] as? [[String: Any]]
                self?.homeModel.repo = items!
                
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else {
                        print("self is already deallocated")
                        return
                    }
                    weakSelf.tableView.reloadData()
                }
            }
        }
        
        homeModel.task?.resume()
    }
    
    //画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetail"{
            let dtlVC = segue.destination as! DetailViewController
            
            dtlVC.homeVC = self
        }
    }
    
    //tableView行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeModel.repo.count
    }
    
    //tableView　cell設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? HomeVCTableViewCell else {
            return UITableViewCell()
        }
        let rp = homeModel.repo[indexPath.row]
        print(rp)
        cell.rpLabel.text = rp["full_name"] as? String ?? ""
        cell.langLabel.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        
        return cell
    }
    
    //セルをクリックしたときの画面遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeModel.index = indexPath.row
        performSegue(withIdentifier: "goToDetail", sender: self)
        
    }
    
    //cellの高さ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

