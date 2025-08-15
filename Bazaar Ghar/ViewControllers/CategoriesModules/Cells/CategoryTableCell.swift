//
//  CategoryTableCell.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 25/09/2023.
//

import UIKit

class CategoryTableCell: UITableViewCell {
    @IBOutlet weak var headerlbl: UILabel!

    @IBOutlet weak var videocategorycollection: UICollectionView!
    @IBOutlet weak var emptyLbl: UILabel!


    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var id = String() {
        didSet {
            getStreamingVideos(limit:30,page:1,categories: [id], city: "")
        }
    }
    weak var navigationController: UINavigationController?

    override func awakeFromNib() {
        super.awakeFromNib()
        videocategorycollection.dataSource = self
        videocategorycollection.delegate = self
        self.videocategorycollection.reloadData()
        // Initialization code
    }
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String],city:String){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                if res.results?.count ?? 0 > 0 {
                    self?.emptyLbl.isHidden = true
                }else {
                    self?.emptyLbl.isHidden = false
                }
                self?.LiveStreamingResultsdata = res.results ?? []
                self?.videocategorycollection.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
extension CategoryTableCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return LiveStreamingResultsdata.count
        
    }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)"
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
            
                return cell
            }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: collectionView.frame.size.width/1.7, height: collectionView.frame.size.height)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = LiveStreamingResultsdata[indexPath.row]
        let vc = New_SingleVideoview.getVC(.videoStoryBoard)
        vc.page = 2
        vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
        vc.indexValue = indexPath.row
        navigationController?.pushViewController(vc, animated: false)
    }
    
  }


////
////
////
//      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//    UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       
//          
//        
//            
//        }
//    
