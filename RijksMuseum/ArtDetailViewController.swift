//
//  ArtDetailViewController.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit
import Kingfisher

/*!
 * @brief Shows full screen image viewer that displays large image of an artwork. Shows action button that opens page in browser
 */
class ArtDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    /// Artobject that holds url for large image
    var artObject: ArtObject!

    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        loadImage()
    }
    
    // MARK: - UI custimization
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.black
        
        setupScrolLView()
        addActionButton()
    }
    
    private func addActionButton() {
        
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actioButtonTouched(_:)))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupScrolLView() {
        
        photoScrollView.minimumZoomScale = 1.0
        photoScrollView.maximumZoomScale = 20.0
    }

    // MARK: - Zooming and panning
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        photoImageView.center = view.center
    }
    
    // MARK: - Data integration
    
    private func loadImage() {
        
        if artObject != nil, let url = artObject.webImageURL {
            photoImageView.kf.setImage(with: url)
        }
        else {
            photoImageView.image = nil
        }
    }
    
    // MARK: - Actions
    
    @objc func actioButtonTouched(_ sender: Any) {
        
        if artObject != nil, let url = artObject.webURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
