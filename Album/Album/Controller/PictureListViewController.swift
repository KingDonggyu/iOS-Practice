//
//  PictureListViewController.swift
//  Album
//
//  Created by 김동규 on 2022/01/20.
//

import UIKit
import Photos

class PictureListViewController: UIViewController {
    
    var album: AlbumModel = AlbumModel(name: "", count: 0, collection: PHAssetCollection())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        
    }
    
    // MARK: - Custom Methods
    
    // MARK: Add Views
    func addViews() {
        self.addNavigationBar()
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
    
        let navItem = UINavigationItem(title: album.name)
        navItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: nil)
        navBar.items = [navItem]
        
        self.view.addSubview(navBar)
    }
    
    
}

//extension PictureListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}
//
//extension PictureListViewController: PHPhotoLibraryChangeObserver {
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        <#code#>
//    }
//
//
//}
