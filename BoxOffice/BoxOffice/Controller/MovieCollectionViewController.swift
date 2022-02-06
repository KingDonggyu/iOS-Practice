//
//  MovieCollectionViewController.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/01.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    
    var movies: [Movie] = []
    var activityIndicator: UIActivityIndicatorView!
    let cellIdentifier: String = "movieCollectionCell"
    let nextVC: String = "MovieDetailViewContoller"
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addViews()
        
        self.movieCollectionView.dataSource = self
        self.movieCollectionView.delegate = self
        
        self.movieCollectionView.refreshControl = UIRefreshControl()
        self.movieCollectionView.refreshControl?.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoivesNoti(_:)), name: DidReceiveMovieListNoti, object: nil)
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
        self.movieCollectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: Notification
    @objc func didReceiveMoivesNoti(_ noti: Notification) {
        
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else {
            return
        }
        
        self.movies = movies
        
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Add Views
    func addViews() {
        self.addNavigationItem()
        self.setFlowLayout()
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
    
    func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30)
        flowLayout.itemSize = CGSize(width: 150, height: 300)
        
        movieCollectionView.collectionViewLayout = flowLayout
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MovieCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: MovieCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? MovieCollectionCell else {
            return UICollectionViewCell()
        }
        
        let movie: Movie = self.movies[indexPath.item]
        
        cell.movieTitle.text = movie.title
        cell.movieInfo.text = movie.shortInfoLabel
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
                if let index: IndexPath = collectionView.indexPath(for: cell) {
                    if index.item == indexPath.item {
                        cell.movieImageView.image = UIImage(data: imageDate)
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.movieCollectionView.deselectItem(at: indexPath, animated: true)
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: self.nextVC) as? MovieDetailViewController else {
            return
        }
        
        nextVC.movie = self.movies[indexPath.item]
        
        self.show(nextVC, sender: self)
    }
}
