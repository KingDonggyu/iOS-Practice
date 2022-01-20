//
//  AlbumListViewController.swift
//  Album
//
//  Created by 김동규 on 2022/01/20.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    // MARK: - Properties
    var albumModel: [AlbumModel] = [AlbumModel]()
    var fetchResult: [PHFetchResult<PHAsset>] = []
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    
    var fetchOptions: PHFetchOptions {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return options
    }
    
    let cellIdentifier: String = "AlbumCell"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        
        aurhorizePhotoAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        albumCollectionView.reloadData()
    }
    
    // MARK: - Custom Methods
    func aurhorizePhotoAccess() {
        
        let photoAurhorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAurhorizationStatus {
        case .notDetermined:
            print("응답 안함")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .denied:
                    print("접근 불허")
                case .authorized:
                    print("접근 허용")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.albumCollectionView.reloadData()
                    }
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        case .denied:
            print("접근 불허")
        case .authorized:
            print("접근 허용")
            self.requestCollection()
            self.albumCollectionView.reloadData()
        case .limited:
            print("제한된 접근 허용")
        default: break
        }
        
        PHPhotoLibrary.shared().register(self)
    }
    
    func requestCollection() {
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let personalAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        
        [cameraRoll, favorites, personalAlbums].forEach {
            
            $0.enumerateObjects { collection, _, _ in
                let assetFetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: self.fetchOptions)
                let albumCount = assetFetchResult.count
                
                guard let albumTitle: String = collection.localizedTitle else {
                    return
                }
                
                let newAlbum = AlbumModel(name: albumTitle, count: albumCount, collection: collection)
                self.albumModel.append(newAlbum)
            }
            
        }
        
        self.addAlbums(collections: [cameraRoll, favorites, personalAlbums])
    }
    
    func addAlbums(collections: [PHFetchResult<PHAssetCollection>]) {
        for collection in collections {
            for i in 0..<collection.count {
                let collection = collection.object(at: i)
                self.fetchResult.append(PHAsset.fetchAssets(in: collection, options: fetchOptions))
            }
        }
    }
    
    // MARK: Add Views
    func addViews() {
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
    
        let navItem = UINavigationItem(title: "앨범")
        navBar.items = [navItem]
        
        self.view.addSubview(navBar)
    }
    
    func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 180, height: 220)
        
        albumCollectionView.collectionViewLayout = flowLayout
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension AlbumListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? AlbumCell else {
            return UICollectionViewCell()
        }
        
        if let asset = fetchResult[indexPath.item].firstObject {
            let options: PHImageRequestOptions = PHImageRequestOptions()
            options.resizeMode = .exact
            
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.albumImageView?.image = image})
        }
        
        cell.albumTitleLabel.text = albumModel[indexPath.item].name
        cell.albumCountLabel.text = String(fetchResult[indexPath.item].count)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "PictureListViewController") as? PictureListViewController else {
            return
        }
        
        nextViewController.album = albumModel[indexPath.item]
        
        self.show(nextViewController, sender: self)
    }
    
    
}

// MARK: - PHPhotoLibraryChangeObserver
extension AlbumListViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        for i in 0..<albumModel.count {
            if let changes = changeInstance.changeDetails(for: self.fetchResult[i]) {
                fetchResult[i] = changes.fetchResultAfterChanges
                
                OperationQueue.main.addOperation {
                    self.albumCollectionView.reloadSections(IndexSet(0...0))
                }
            }
        }
    }
    
    
}
