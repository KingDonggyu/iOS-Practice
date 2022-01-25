//
//  PictureListViewController.swift
//  Album
//
//  Created by 김동규 on 2022/01/20.
//

import UIKit
import Photos

enum Mode {
    case view, select
}

class PictureListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var sortButtonItem: UIBarButtonItem!
    @IBOutlet weak var trashButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    var album: AlbumModel = AlbumModel(name: "", count: 0, collection: PHAssetCollection())
    var fetchResult: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    var imageAscending = true
    
    var selectedIndexPath: [IndexPath: Bool] = [:]
    var numberOfSelected = 0
    
    let cellIdentifier: String = "PictureCell"
    
    var currentMode: Mode = .view {
        didSet {
            switch currentMode {
            case .view:
                
                for (key, value) in selectedIndexPath {
                    if value {
                        if let cell = pictureCollectionView.cellForItem(at: key) as? PictureCell {
                            cell.isSelected = false
                            cell.pictureImageView.alpha = 1.0
                        }
                    }
                }
                
                selectedIndexPath.removeAll()
                
                self.navigationItem.title = self.album.name
                self.navigationItem.rightBarButtonItem?.title = "선택"
                
                self.sortButtonItem.isEnabled = true
                self.shareButtonItem.isEnabled = false
                self.trashButtonItem.isEnabled = false
                self.pictureCollectionView.allowsMultipleSelection = false
                
                self.numberOfSelected = 0
                
            case .select:
                
                self.navigationItem.title = "항목 선택"
                self.navigationItem.rightBarButtonItem?.title = "취소"
                
                self.sortButtonItem.isEnabled = false
                self.pictureCollectionView.allowsMultipleSelection = true
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViews()
        
        pictureCollectionView.dataSource = self
        pictureCollectionView.delegate = self
        
        requestAsset()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pictureCollectionView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func touchUpSelectButtonItem(_ sender: UIBarButtonItem) {
        currentMode = currentMode == .view ? .select : .view
    }
    
    @IBAction func touchUpShareButtonItem(_ sender: UIBarButtonItem) {
        self.showActivityView()
    }
    
    @IBAction func touchUpTrashButtonItem(_ sender: UIBarButtonItem) {
        var deleteImages = [PHAsset]()
        
        for (key, value) in selectedIndexPath {
            if value {
                deleteImages.append(self.fetchResult.object(at: key.item))
            }
        }
        
        for i in 0..<deleteImages.count {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([deleteImages[i]] as NSArray)
            },completionHandler: nil)
        }
        
        currentMode = .view
    }
    
    @IBAction func touchUpSortButtonItem(_ sender: UIBarButtonItem) {
        
        if self.imageAscending {
            self.imageAscending = false
            sortButtonItem.title = "과거순"
        } else {
            self.imageAscending = true
            sortButtonItem.title = "최신순"
        }
        
        self.requestAsset()
    }
    
    // MARK: - Custom Methods
    func requestAsset() {
        let collection = album.collection
        
        var fetchOptions: PHFetchOptions {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: self.imageAscending)]
            return options
        }
        
        self.fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        
        pictureCollectionView.reloadData()
    }
    
    // MARK: Init Views
    func initViews() {
        self.addNavigationBar()
        self.setFlowLayout()
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
        
        // Bar Item
        let selectButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(touchUpSelectButtonItem(_:)))
        
        self.navigationItem.title = album.name
        self.navigationItem.rightBarButtonItem = selectButtonItem
        self.view.addSubview(navBar)
    }
    
    func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 7
        flowLayout.minimumLineSpacing = 7
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let width = (UIScreen.main.bounds.width - 14) / 3
        flowLayout.itemSize = CGSize(width: width, height: width)
        
        pictureCollectionView.collectionViewLayout = flowLayout
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PictureListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? PictureCell else {
            return UICollectionViewCell()
        }
        
        let asset: PHAsset = self.fetchResult.object(at: indexPath.item)
        
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.pictureImageView?.image = image })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PictureCell else {
            return
        }
    
        switch currentMode {
        case .view:
            let selectedImage = self.fetchResult.object(at: indexPath.item)
            
            if let nextViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "PictureDetailViewController") as? PictureDetailViewController {
                
                nextViewContoller.picture = selectedImage
                self.show(nextViewContoller, sender: self)
            }
            
        case .select:
            cell.pictureImageView.alpha = 0.5
            selectedIndexPath[indexPath] = true
            
            numberOfSelected += 1
            navigationItem.title = "\(numberOfSelected)장 선택"
            
            if numberOfSelected > 0 {
                shareButtonItem.isEnabled = true
                trashButtonItem.isEnabled = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PictureCell else {
            return
        }
        
        switch currentMode {
        case .view:
            break
        case .select:
            cell.pictureImageView.alpha = 1
            selectedIndexPath[indexPath] = false
            
            numberOfSelected -= 1
            navigationItem.title = "\(numberOfSelected)장 선택"
            
            if numberOfSelected == 0 {
                navigationItem.title = "항목 선택"
                shareButtonItem.isEnabled = false
                trashButtonItem.isEnabled = false
            }
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PictureListViewController: PHPhotoLibraryChangeObserver {
 
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if let changes = changeInstance.changeDetails(for: self.fetchResult) {
            self.fetchResult = changes.fetchResultAfterChanges
            
            OperationQueue.main.addOperation {
                self.pictureCollectionView.reloadSections(IndexSet(0...0))
            }
        }
    }
}

// MARK: - UIActivityViewController
extension PictureListViewController {
    
    func showActivityView() {
        var shareImages = [UIImage]()
        
        for (key, value) in selectedIndexPath {
            if value {
                let asset: PHAsset = self.fetchResult.object(at: key.item)
                
                self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                    
                    if let selectedImage = image {
                        shareImages.append(selectedImage)
                    }
                })
            }
        }
        
        let activityViewContoller = UIActivityViewController(activityItems: shareImages, applicationActivities: nil)
        self.present(activityViewContoller, animated: true, completion: nil)
    }
}
