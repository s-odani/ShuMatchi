//
//  ViewController.swift
//  enPittest
//
//  Created by 小室悠太 on 2020/07/24.
//  Copyright © 2020 Yuta Omuro. All rights reserved.
//

import UIKit

class NameViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
   
    @IBOutlet weak var tableView: UITableView!
    
    let tableData = ["八神月","R","高田","渋井丸拓夫","渋井丸拓夫"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        cell.imageView!.image = UIImage(named:"checkImage")
        return cell
    }
    
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath: IndexPath){
        
        let nextVC = storyboard?.instantiateViewController(identifier: "MainChat") as! ChatViewController
        
        nextVC.toDoString = tableData[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/10
    }
    

}

