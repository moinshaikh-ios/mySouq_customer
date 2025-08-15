//
//  VideoPlayerViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 20/09/2023.
//

import UIKit

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoTblV: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTblV.delegate = self
        videoTblV.dataSource = self
        // Do any additional setup after loading the view.
    }
    


}

extension VideoPlayerViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoPlayerTableViewCell", for: indexPath) as! VideoPlayerTableViewCell
        
        cell.textLabel?.text = "OK"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
}
