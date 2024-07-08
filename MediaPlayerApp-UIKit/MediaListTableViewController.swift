//
//  MediaListTableViewController.swift
//  MediaPlayerApp-UIKit
//
//  Created by 박지혜 on 7/5/24.
//

import UIKit

class MediaListTableViewController: UITableViewController {
    let items: [MediaItem] = MediaItem.samples
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "MediaPlayer"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mediaItemCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaItemCell", for: indexPath)

        let item = items[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.image = UIImage(systemName: item.isVideo ? "video.square.fill" : "music.note")
        // 셀의 오른쪽에 액세서리 뷰를 표시(>)
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = config

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]

        let mediaPlayerViewController = MediaPlayerViewController()
        navigationController?.pushViewController(mediaPlayerViewController, animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: MediaListTableViewController())
}
