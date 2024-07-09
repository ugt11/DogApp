//
//  CollectionViewController.swift
//  DogApp
//
//  Created by spark-04 on 2024/06/10.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var breed: String?
    var dogImages: [String] = []
    
    struct DogImagesResponse: Codable {
        let message: [String]
        let status: String
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchDogImages()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: collectionView.bounds.width / 2 - 15, height: 150)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        
        // ナビゲーションバーのタイトルを設定
        if let breed = breed {
            self.title = breed.capitalized
        }
        
        // ナビゲーションバーのタイトルの色を設定
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray6]
            navigationBar.barTintColor = UIColor.black
            // ナビゲーションバーの透過性を無効にする
            navigationBar.isTranslucent = false
        }
    }
    
    func fetchDogImages() {
        guard let breed = breed, let url = URL(string: "https://dog.ceo/api/breed/\(breed)/images") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(DogImagesResponse.self, from: data)
                let dogImages = response.message
                DispatchQueue.main.async {
                    self?.dogImages = dogImages
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogCollectionViewCell
        let imageURL = dogImages[indexPath.item]
        cell.configure(with: imageURL)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail",
           let dogDetailVC = segue.destination as? DogDetailViewController,
           let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            dogDetailVC.imageURLs = dogImages
            dogDetailVC.currentIndex = selectedIndexPath.item
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
