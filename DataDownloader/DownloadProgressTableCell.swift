//
//  DownloadProgressTableCell.swift
//  DownloadData
//
//  Created by Vinay Kumar on 20/11/19.
//  Copyright © 2019 Vinay Kumar. All rights reserved.
//

import UIKit
import MZDownloadManager

class DownloadProgressTableCell: UITableViewCell {

    @IBOutlet var fileName : UILabel?
    @IBOutlet var downloadDetails : UILabel?
    @IBOutlet var downloadProgress : UIProgressView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCellForRowAtIndexPath(_ indexPath : IndexPath, downloadModel: MZDownloadModel) {
        
        self.fileName?.text = "File Name: \(downloadModel.fileName!)"
        self.downloadProgress?.progress = downloadModel.progress
        
        var fileSize = "Gathering information..."
        if let _ = downloadModel.file?.size {
            fileSize = String(format: "%.2f %@", (downloadModel.file?.size)!, (downloadModel.file?.unit)!)
        }
        
        var downloadedFileSize = "File Size Calculating..."
        if let _ = downloadModel.downloadedFile?.size {
            downloadedFileSize = String(format: "%.2f %@", (downloadModel.downloadedFile?.size)!, (downloadModel.downloadedFile?.unit)!)
        }
        
        let downloadDetailsText = NSMutableString()
        downloadDetailsText.appendFormat("File Size: \(fileSize)\nDownloaded: \(downloadedFileSize) \nStatus: \(downloadModel.status)" as NSString, downloadModel.progress * 100.0)
        downloadDetails?.text = downloadDetailsText as String
    }
}

