//
//  ViewController.swift
//  enPittest
//
//  Created by 小室悠太 on 2020/07/24.
//  Copyright © 2020 Yuta Omuro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class NameViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
   
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = ["八神月","R","高田","渋井丸拓夫","渋井丸拓夫"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        fetchDataRef()
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tableData.count)
        print("tablecount")
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        //guard let industry = UserDefaults.standard.object(forKey: "industry") as? String else { print("error")}
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
    
    func fetchDataRef(){
        guard let industry = UserDefaults.standard.object(forKey: "industry") as? String else {return}
            
        
        //print(industry)
        
        let ref = Database.database().reference().child("users")

        ref.queryOrdered(byChild: "industry").queryEqual(toValue: industry).observe(.value, with: { snapshot in
            if let user = snapshot.value as? [String : AnyObject] {
                for key in user {
                    //print(key.key)
                    let sender = key.value["sender"]! ??  0
                    //print(key.value["sender"]! ??  0)
                    //print(sender)
                    self.tableData.append(sender as! String)
                    }
                print("testPlace")
                print(self.tableData)
                self.tableView.reloadData()
            }
        })
    
        //self.tableView.reloadData()
    }
}

