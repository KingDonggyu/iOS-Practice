//
//  MovieTableViewController.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/01/30.
//

import UIKit

class MoviewTableViewController: UIViewController {
    
    var movies: [Movie] = []
    var activityIndicator: UIActivityIndicatorView!
    let cellIdentifier: String = "movieTableCell"
    let nextVC: String = "MovieDetailViewContoller"

    @IBOutlet weak var movieTableView: UITableView!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
        
        self.movieTableView.refreshControl = UIRefreshControl()
        self.movieTableView.refreshControl?.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoivesNoti(_:)),
                                               name: DidReceiveMovieListNoti, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestMovieList(type: MovieListType.shared.type)
    }
    
    // MARK: - IBActions
    @IBAction func touchUpShowActionSheetButton(_ sender: UIBarButtonItem) {
        showAlertContoller(vc: self, style: UIAlertController.Style.actionSheet)
    }
    
    // MARK: - Custom Methods
    @objc func pullToRefresh(_ sender: Any) {
        // 새로고침 시 갱신 되어야할 내용
        requestMovieList(type: MovieListType.shared.type)
        // 당겨서 새로고침 종료
        self.movieTableView.refreshControl?.endRefreshing()
    }
    
    // MARK: Notification
    @objc func didReceiveMoivesNoti(_ noti: Notification) {

        if let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] {
            self.movies = movies
        }
        
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Add Views
    func addViews() {
        self.addNavigationItem()
        self.activityIndicator = addActivityIndicator(vc: self)
        self.view.addSubview(self.activityIndicator)
    }
    
    func addNavigationItem() {

        // Nabigation Item
        let sortButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(self.touchUpShowActionSheetButton(_:)))
        sortButtonItem.tintColor = .white
        
        self.navigationItem.title = MovieListType.shared.title
        self.navigationItem.rightBarButtonItem = sortButtonItem
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MoviewTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: MovieTableCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MovieTableCell else {
            return UITableViewCell()
        }
        
        let movie: Movie = self.movies[indexPath.row]
        
        cell.movieTitle.text = movie.title
        cell.movieInfo.text = movie.infoLabel
        cell.movieDate.text = movie.dateLabel
        cell.gradeImageView.image = UIImage(named: movie.gradeImageName)
        cell.movieImageView.image = nil
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: movie.thumb) else {
                return
            }
            guard let imageDate: Data = try? Data(contentsOf: imageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.movieImageView.image = UIImage(data: imageDate)
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.movieTableView.deselectRow(at: indexPath, animated: true)
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: self.nextVC) as? MovieDetailViewController else {
            return
        }
        
        nextVC.movie = self.movies[indexPath.row]
        
        self.show(nextVC, sender: self)
    }
}

