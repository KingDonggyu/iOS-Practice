//
//  CommentsContainerViewController.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/05.
//

import UIKit

class CommentsContainerViewController: UIViewController {
    
    var movieId: String!
    var comments: [MovieComment] = []
    
    let cellIdentifier: String = "commentCell"
    
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentTableView.dataSource = self
        self.commentTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMovieCommentsNoti(_:)), name: DidReceiveMovieCommentsNoti, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestMovieComments(id: self.movieId)
    }
    
    // MARK: Notification
    @objc func didReceiveMovieCommentsNoti(_ noti: Notification) {
        
        guard let movieComments: [MovieComment] = noti.userInfo?["comments"] as? [MovieComment] else {
            return
        }
        self.comments = movieComments
        
        DispatchQueue.main.async {
            self.commentTableView.reloadData()
        }
    }
}

extension CommentsContainerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CommentsTableCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CommentsTableCell else {
            return UITableViewCell()
        }
        
        let comment = self.comments[indexPath.row]
        
        cell.writerLabel.text = comment.writer
        cell.dateAndTimeLabel.text = "\(comment.timestamp)"
        cell.contentsTextView.text = comment.contents
        
        return cell
    }
}
