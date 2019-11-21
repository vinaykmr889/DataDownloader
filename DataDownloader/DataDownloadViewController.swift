//
//  ViewController.swift
//  DownloadData
//
//  Created by Vinay Kumar on 20/11/19.
//  Copyright © 2019 Vinay Kumar. All rights reserved.
//

import UIKit
import MZDownloadManager

class DataDownloadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputUrl: UITextField!
    
    lazy var downloadManager: MZDownloadManager = {
        [unowned self] in
        let sessionIdentifer: String = "com.iosDevelopment.MZDownloadManager.BackgroundSession"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshCellAtIndex(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        if let cell = cell {
            let downloadCell = cell as! DownloadProgressTableCell
            downloadCell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadManager.downloadingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier : NSString = "DownloadProgressTableCell"
        let cell : DownloadProgressTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! DownloadProgressTableCell
        
        if (downloadManager.downloadingArray.count > indexPath.row){
            let downloadModel = downloadManager.downloadingArray[indexPath.row]
            cell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        }
        
        return cell
    }
    
    @IBAction func startDownloading(_ sender: UIButton) {
        let myDownloadPath = MZUtility.baseFilePath + "/Download Data"
    
        var fileURL: String = ""
        var fileName: String = ""
        if (self.inputUrl?.text != ""){
            fileURL = self.inputUrl?.text ?? ""
            fileName = URL(string: fileURL)?.lastPathComponent ?? ""
        } else {
            // Default URL when user is not entering any URL
            fileURL = "https://scholar.princeton.edu/sites/default/files/oversize_pdf_test_0.pdf"
            fileName = "Default PDF download"
        }
        
        self.downloadManager.addDownloadTask(fileName as String, fileURL: fileURL as String, destinationPath: myDownloadPath)
        
    }
}

extension DataDownloadViewController: MZDownloadManagerDelegate {
    
    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
        self.tableView.reloadData()
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellAtIndex(downloadModel, index: index)
    }
}

