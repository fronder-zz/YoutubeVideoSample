//
//  VideoListViewController.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit

class VideoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: Variables
    
    let viewModel = VideoViewModel()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.didUpdateData = update
    }
    

    // MARK: Private
    
    fileprivate func update() {
        tableView.reloadData()
    }
}


// MARK: UITableViewDataSource/UITableViewDelegate

extension VideoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.reuseIdentifier, for: indexPath) as! VideoTableViewCell
        cell.delegate = self
        
        let object = viewModel.items[indexPath.row]
        cell.setModel(model: object)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.count()-1, viewModel.dataLoaded {
            if let text = searchBar.text, text.count > 0 {
                viewModel.fetchSearch(searchParameter: text, clear: false)
                searchBar.resignFirstResponder()
            } else {
                viewModel.fetchVideos(clear: false)
            }
        }
    }
}


// MARK: VideoTableViewCellDelegate

extension VideoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count > 0 {
            viewModel.fetchSearch(searchParameter: text, clear: true)
            searchBar.resignFirstResponder()
        }
    }
}


// MARK: VideoTableViewCellDelegate

extension VideoListViewController: VideoTableViewCellDelegate {
    
    func videoTableViewCellPlayDidClick(object: VideoObject) {
        let vc = VideoPlayerViewController.instantiate()
        vc.object = object
        present(vc, animated: true, completion: nil)
    }
}
