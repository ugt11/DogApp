//
//  DogDetailViewController.swift
//  DogApp
//
//  Created by spark-04 on 2024/06/12.
//

import UIKit

class DogDetailViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageURLs: [String] = []
    var currentIndex: Int = 0
    
    var swipeRightGesture: UISwipeGestureRecognizer!
    var swipeLeftGesture: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        
        imageView.isUserInteractionEnabled = true
        
        addSwipeGestures()
        addDoubleTapGesture()
        
        loadImage(at: currentIndex)
    }
    
    func addSwipeGestures() {
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRightGesture.direction = .right
        swipeRightGesture.delegate = self
        imageView.addGestureRecognizer(swipeRightGesture)
        
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeftGesture.direction = .left
        swipeLeftGesture.delegate = self
        imageView.addGestureRecognizer(swipeLeftGesture)
    }
    
    func addDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        imageView.addGestureRecognizer(doubleTapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        guard scrollView.zoomScale == scrollView.minimumZoomScale else { return }
        
        if gesture.direction == .right {
            currentIndex = (currentIndex - 1 + imageURLs.count) % imageURLs.count
        } else if gesture.direction == .left {
            currentIndex = (currentIndex + 1) % imageURLs.count
        }
        loadImage(at: currentIndex)
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let pointInView = gesture.location(in: imageView)
        let newZoomScale = scrollView.zoomScale > scrollView.minimumZoomScale ? scrollView.minimumZoomScale : scrollView.maximumZoomScale
        
        let scrollViewSize = scrollView.bounds.size
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (width / 2.0)
        let y = pointInView.y - (height / 2.0)
        
        let rectToZoomTo = CGRect(x: x, y: y, width: width, height: height)
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let isZoomed = scrollView.zoomScale > scrollView.minimumZoomScale
        swipeRightGesture.isEnabled = !isZoomed
        swipeLeftGesture.isEnabled = !isZoomed
    }
    
    func loadImage(at index: Int) {
        guard let url = URL(string: imageURLs[index]) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                UIView.transition(with: self?.imageView ?? UIImageView(), duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self?.imageView.image = image
                }, completion: nil)
                self?.scrollView.zoomScale = self?.scrollView.minimumZoomScale ?? 1.0
            }
        }.resume()
    }
}
