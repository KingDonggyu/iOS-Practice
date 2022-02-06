//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by 김동규 on 2022/02/01.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    var movieDetail: MovieDetail!
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieGenrnAndTimeLabel: UILabel!
    @IBOutlet weak var movieReservationLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieAudienceLabel: UILabel!
    @IBOutlet weak var movieSynopsisLabel: UITextView!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieActorsLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollContentView.isHidden = true
        self.addViews()
        self.sendDataToChildren()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMovieDetailNoti(_:)), name: DidReceiveMovieDetailNoti, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestMovieDetail(id: self.movie.id)
    }
    
    // MARK: - Custom Methods
    
    // MARK: Notification
    @objc func didReceiveMovieDetailNoti(_ noti: Notification) {
        
        guard let movieDetail: MovieDetail = noti.userInfo?["movieDetail"] as? MovieDetail else {
            return
        }
        self.movieDetail = movieDetail
        
        DispatchQueue.main.async {
            self.initMovieInfo()
            self.activityIndicator.stopAnimating()
            self.scrollContentView.isHidden = false
        }
    }
    
    // MARK: Add Views
    func addViews() {
        self.navigationItem.title = self.movie.title
        self.navigationController?.navigationBar.topItem?.title = "영화목록"
        
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.borderColor = UIColor.gray.cgColor
        
        self.activityIndicator = addActivityIndicator(vc: self)
        self.view.addSubview(self.activityIndicator)
    }
}

// MARK: - Initialization
extension MovieDetailViewController {
    func initMovieInfo() {
        
        self.movieDateLabel.text = "\(self.movieDetail.date) 개봉"
        self.movieGenrnAndTimeLabel.text = "\(self.movieDetail.genre)/\(self.movieDetail.duration)분"
        self.movieReservationLabel.text = "\(self.movieDetail.reservation_grade)위 \(self.movieDetail.reservation_rate)%"
        self.movieRatingLabel.text = "\(self.movieDetail.user_rating)"
        self.movieSynopsisLabel.text = self.movieDetail.synopsis
        self.movieDirectorLabel.text = self.movieDetail.director
        self.movieActorsLabel.text = self.movieDetail.actor
        
        // label text에 문자 추가
        let str = "\(self.movieDetail.audience)"
        var temp = "\(self.movieDetail.audience)"
        for i in 1...str.count/3 {
            if str.count%3 == 0 && i == str.count/3 { continue }
            temp.insert(",", at: str.index(str.endIndex, offsetBy: -3*i))
        }
        self.movieAudienceLabel.text = temp
        
        // label에 image 추가
        let text = "\(self.movieDetail.title) "
        let attirubutedString = NSMutableAttributedString(string: text)
        let imageAttachment = NSTextAttachment()

        imageAttachment.image = UIImage(named: self.movie.gradeImageName)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 17, height: 17)
        attirubutedString.append(NSAttributedString(attachment: imageAttachment))
        self.movieTitleLabel.attributedText = attirubutedString
        
        // 이미지 로드
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: self.movieDetail.image) else {
                return
            }
            guard let imageDate: Data = try? Data(contentsOf: imageURL) else {
                return
            }
            DispatchQueue.main.async {
                self.movieImageView.image = UIImage(data: imageDate)
            }
        }
    }
}

extension MovieDetailViewController {
    
    func sendDataToChildren() {
        let CVC = children.last as! CommentsContainerViewController
        CVC.movieId = self.movie.id
    }
}
