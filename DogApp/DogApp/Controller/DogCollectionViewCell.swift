//
//  Dog.swift
//  DogApp
//
//  Created by spark-04 on 2024/06/11.
//

import Foundation
import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with imageURL: String) {
        
        guard let url = URL(string: imageURL) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.imageView?.image = image
            }
        } .resume()
        }
    }

