//
//  PictureDetailViewController.swift
//  Album
//
//  Created by 김동규 on 2022/01/25.
//

import UIKit
import Photos

class PictureDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var favoriteButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var trashButtinItem: UIBarButtonItem!
    
    // MARK: - Properties
    var picture: PHAsset = PHAsset()
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    // MARK: - IBActions
    @IBAction func touchUpFavoriteButtonItem(_ sender: UIBarButtonItem) {
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: self.picture)
            request.isFavorite = !self.picture.isFavorite
        }, completionHandler: { success, error in
            if success {
                OperationQueue.main.addOperation {
                    sender.image = self.picture.isFavorite ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
                }
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    @IBAction func touchUpShareButtonItem(_ sender: UIBarButtonItem) {
        
        self.showActivityView()
    }
    
    @IBAction func touchUpTrashButtonItem(_ sender: UIBarButtonItem) {
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([self.picture] as NSFastEnumeration)
        }, completionHandler: { success, error in
            if success {
                OperationQueue.main.addOperation {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    // MARK: - Custom Methods
    
    // MARK: Init Views
    func initViews() {
        
        setImageView()
        addNavigationBar()
    }
    
    func setImageView() {
        
        imageManager.requestImage(for: picture, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: { (image, _) in
            OperationQueue.main.addOperation {
                self.pictureImageView.image = image
                if self.picture.isFavorite {
                    self.favoriteButtonItem.image = UIImage(systemName: "heart.fill")
                }
            }
        })
    }
    
    func addNavigationBar() {
        
        // Safe Area
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let statusBarHeight = windowScene?.windows.first?.safeAreaInsets.top ?? 0
        
        // Navigation Bar
        let navBar = UINavigationBar(frame: .init(x: 0, y: statusBarHeight, width: view.frame.width, height: statusBarHeight))
        navBar.isTranslucent = false
        navBar.backgroundColor = .systemBackground
        
        // Navigation Title
        guard let pictureDateTime = picture.creationDate else {
            return
        }
        
        var dateFormatter: DateFormatter{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }
        
        var timeFormatter: DateFormatter{
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .medium
            return timeFormatter
        }
        
        let date = UILabel(frame: CGRect(x: 0, y: 3, width: 0, height: 0))
        date.text = dateFormatter.string(from: pictureDateTime)
        date.backgroundColor = UIColor.clear
        date.textColor = UIColor.black
        date.font = UIFont.boldSystemFont(ofSize: 17)
        date.sizeToFit()
        
        let time = UILabel(frame: CGRect(x: 0, y: 25, width: 0, height: 0))
        time.text = timeFormatter.string(from: pictureDateTime)
        time.backgroundColor = UIColor.clear
        time.textColor = UIColor.gray
        time.font = UIFont.systemFont(ofSize: 14)
        time.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(date.frame.size.width, time.frame.size.width), height: statusBarHeight))
        
        titleView.addSubview(date)
        titleView.addSubview(time)
        
        self.navigationItem.titleView = titleView
        self.view.addSubview(navBar)
    }
    
}

// MARK: - UIActivityViewController
extension PictureDetailViewController {
    
    func showActivityView() {
        
        var shareImages = [UIImage]()
        
        imageManager.requestImage(for: picture, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: { (image, _) in
            if let selectedImage = image {
                shareImages.append(selectedImage)
            }
        })
        
        let activityViewContoller = UIActivityViewController(activityItems: shareImages, applicationActivities: nil)
        self.present(activityViewContoller, animated: true, completion: nil)
    }
}
