//
//  ThumbnailsViewController.swift
//  ImageViewer
//
//  Created by Zeno Foltin on 07/07/2016.
//  Copyright © 2016 MailOnline. All rights reserved.
//

import UIKit

class ThumbnailsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationBarDelegate {

    private let reuseIdentifier = "ImageCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var isAnimating = false
    private let rotationAnimationDuration = 0.2

    var onItemSelected: ((Int) -> Void)?
    let layout = UICollectionViewFlowLayout()
    var imageProvider: ImageProvider!
    var closeButton: UIButton?
    var closeLayout: ButtonLayout?

    required init(imageProvider: ImageProvider) {
        self.imageProvider = imageProvider

        super.init(collectionViewLayout: layout)

        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func rotate() {
        guard isPortraitOnly() else { return }

        guard UIDevice.current.orientation.isFlat == false &&
            isAnimating == false else { return }

        isAnimating = true

        UIView.animate(withDuration: rotationAnimationDuration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] () -> Void in
            self?.view.transform = rotationTransform()
            self?.view.bounds = rotationAdjustedBounds()
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()

            })
        { [weak self] finished  in
            self?.isAnimating = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenWidth = self.view.frame.width
        layout.sectionInset = UIEdgeInsets(top: 50, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: screenWidth/3 - 8, height: screenWidth/3 - 8)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4

        self.collectionView?.register(ThumbnailsCell.self, forCellWithReuseIdentifier: "ImageCell")

        addCloseButton()
    }

    private func addCloseButton() {
        guard let closeButton = closeButton, let closeLayout = closeLayout else { return }

        switch closeLayout {
        case .PinRight(let marginTop, let marginRight):
            closeButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
            closeButton.frame.origin.x = self.view.bounds.size.width - marginRight - closeButton.bounds.size.width
            closeButton.frame.origin.y = marginTop
        case .PinLeft(let marginTop, let marginLeft):
            closeButton.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
            closeButton.frame.origin.x = marginLeft
            closeButton.frame.origin.y = marginTop
        }

        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        self.view.addSubview(closeButton)
    }

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageProvider.imageCount
    }

	//func collecti
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ThumbnailsCell
        imageProvider.provideImage(atIndex: indexPath.row, completion: { image in
            cell.imageView.image = image
        })
        return cell
    }

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        onItemSelected?(indexPath.row)
        close()
    }
}
