//
//  Shake_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 25/07/2024.
//

import UIKit

class Shake_ViewController: UIViewController {
    @IBOutlet weak var shake_collect: UICollectionView!
    
    @IBOutlet weak var OnBaordImages: UIImageView!
    @IBOutlet weak var onBoardSubTitles: UILabel!
    @IBOutlet weak var onBoardTitles: UILabel!
    var images = ["onboard1", "onboard2", "onboard3"]
    var labels = ["Engagement and experience", "Shake It", "Shopping beyound boundaries"]
    var descriptions = ["Interact and enjoy the physical like experience to find the right product" , "Shake your device to transform it into a live shopping experience", " Now shop authentic products from KSA, China and Pakistan." ]
    var currentIndex = 0
    var pdfImages: [String] = ["indicator_1", "indicator_2", "indicator_3"]
    
    var indexPath : IndexPath?
    var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        shake_collect.delegate = self
        shake_collect.dataSource = self
        self.tabBarController?.tabBar.isHidden = true
        if let layout = shake_collect.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.minimumLineSpacing = 0 // Set spacing between items to zero
                    layout.minimumInteritemSpacing = 0 // Set spacing between items to zero
                }

                shake_collect.isPagingEnabled = true
                shake_collect.showsHorizontalScrollIndicator = false
        
        
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let nextIndex = currentIndex + 1

         // Ensure the next index is within the bounds of the collection view's items
         if nextIndex < labels.count {
             let indexPath = IndexPath(item: nextIndex, section: 0)
             shake_collect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
         }else {
             appDelegate.GotoDashBoard(ischecklogin: false)
         }
    
    }
    
}
extension Shake_ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shake_CollectionViewCell", for: indexPath) as! Shake_CollectionViewCell
        
        cell.bgimg.image = UIImage(named: images[indexPath.item])
        cell.skipbtn.addTarget(self, action: #selector(skipbtn), for: .touchUpInside)
        return cell
        
    }
    @objc func skipbtn(sender: UIButton) {
        appDelegate.GotoDashBoard(ischecklogin: false)
    }
    
    @objc func nextbtn(sender: UIButton) {
        // Increment the current index to move to the next item
        currentIndex += 1
        
        // If currentIndex reaches the end of the images array
        if currentIndex >= images.count {
            // Navigate to the dashboard if all items are viewed
            appDelegate.GotoDashBoard(ischecklogin: false)
            return
        }
        
        // Create the new IndexPath for the current item
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        // Scroll to the new item in the collection view
        shake_collect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        // Reload the specific item to ensure the visual representation is updated
        shake_collect.reloadItems(at: [indexPath])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Determine the scroll direction
        let scrollDirection = scrollView.contentOffset.x > lastContentOffset ? "right" : "left"
        lastContentOffset = scrollView.contentOffset.x
        
        // Get the center point of the visible area of the collection view
        let visibleRect = CGRect(origin: shake_collect.contentOffset, size: shake_collect.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        // Get the index path of the item at the visible point
        if let indexPath = shake_collect.indexPathForItem(at: visiblePoint) {
            currentIndex = indexPath.item
            print("Current Index: \(currentIndex)")
            
            // Update UI elements based on the current index
            if currentIndex >= 0 && currentIndex < labels.count {
                onBoardTitles.text = labels[currentIndex]
                onBoardSubTitles.text = descriptions[currentIndex]
                OnBaordImages.image = UIImage(named: pdfImages[currentIndex])
            }
            
            if let cell = shake_collect.cellForItem(at: indexPath) as? Shake_CollectionViewCell {
                // Example: change background color of the cell
                if currentIndex == 0 {
                    cell.shipview.isHidden = false
                } else if currentIndex == 1 {
                    cell.shipview.isHidden = false
                } else {
                    cell.shipview.isHidden = true
                }
            }
        }
        
        // Check if the user is scrolling right past the last item
        if currentIndex == labels.count - 1 && scrollDirection == "right" && scrollView.contentOffset.x > lastContentOffset {
            print("Hello")
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        // Get the index paths of visible items in the collection view
//        let visibleIndexPaths = shake_collect.indexPathsForVisibleItems
//        
//        // Sort index paths to ensure the first visible item is at index 0
//        let sortedIndexPaths = visibleIndexPaths.sorted(by: { $0.item < $1.item })
//        
//        // Check if there are visible items
//        if let firstVisibleIndexPath = sortedIndexPaths.first {
//            // Update currentIndex based on the first visible item's index path
//            currentIndex = firstVisibleIndexPath.item
//            print("Current Index: \(currentIndex)")
//            if currentIndex == 0 {
//                onBoardTitles.text = labels[0]
//            }else if currentIndex == 1 {
//                onBoardTitles.text = labels[1]
//            }else {
//                onBoardTitles.text = labels[2]
//
//            }
//        }
//    }
}
    
    
   


