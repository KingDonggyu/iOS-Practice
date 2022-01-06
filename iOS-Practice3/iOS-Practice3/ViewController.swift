//
//  ViewController.swift
//  iOS-Practice3
//
//  Created by 김동규 on 2022/01/06.
//
// HTTP 통신으로 뉴스앱 만들기

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewMain: UITableView!
    let url = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=2714086cb7d64dadbfdcabae9285a9ef"
    var newsData: Array<Dictionary<String, Any>>?
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let dataJson = data {
                do {
                    // Swift에서는 JSON = Dictionary
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    self.newsData = articles
                    
                    DispatchQueue.main.async {
                        // 통보 -> **background: network / ui: Main**
                        self.TableViewMain.reloadData()
                    }
                } catch {}
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 몇개? - UITableViewDataSource 프로토콜
        if let news = newsData {
            return news.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 무엇? - UITableViewDataSource 프로토콜
        
        //        // 첫번째 방법 - 임의의 셀 만들기 (연습)
        //        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
        //        cell.textLabel?.text = "\(indexPath.row)"
        
        // 두번째 방법 - 스토리보드 + id (실전)
        // 재사용할 수 있는 cell을 정의
        // 부모 자식 친자 확인 : as? - 타입을 안전하게 추론, as! - 타입을 강제로 변환
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        let idx = indexPath.row
        if let news = newsData {
            if let row = news[idx] as? Dictionary<String, Any> {
                if let title = row["title"] as? String {
                    cell.LabelText.text = title
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 클릭
        print("Click: \(indexPath.row)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TableViewMain.dataSource = self
        TableViewMain.delegate = self
        
        getNews()
    }
}

