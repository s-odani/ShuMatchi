//
//  ChatViewController.swift
//  ChatApp3
//
//  Created by apeirogon on 2020/07/24.
//  Copyright © 2020 ShunsukeOdani. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    //スクリーンのサイズ
    let screenSize = UIScreen.main.bounds.size
    var chatArray = [Message]()
    
    //名前の遷移
    var toDoString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoLabel.text = toDoString
        
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
            tableView.rowHeight = UITableView.automaticDimension
             //可変
        
        tableView.estimatedRowHeight = 80
   
        //キーボード
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
        
        //Firebaseからデータをおfetch
        fetchChatData()
        tableView.separatorStyle = .none
        
    }
    //(_ :)は引数が取れる
    @objc func keyboardWillShow(_ notification:NSNotification){
        
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        messageTextField.frame.origin.y = screenSize.height - keyboardHeight - messageTextField.frame.height
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification) {
        
        messageTextField.frame.origin.y = screenSize.height - messageTextField.frame.height
        
        guard let rect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        
        UIView.animate(withDuration: duration) {
            
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
            
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //メッセージの数
        return chatArray.count
        
    }
     
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
         cell.messageLabel.text = chatArray[indexPath.row].message
        
        
         cell.userNameLabel.text = chatArray[indexPath.row].sender
         cell.iconImageView.image = UIImage(named: "dogAvatarImage")
         
        if cell.userNameLabel.text == Auth.auth().currentUser?.email as! String {
            
            cell.messageLabel.backgroundColor = UIColor.flatGreen()
            cell.messageLabel.layer.cornerRadius = 20
            cell.messageLabel.layer.masksToBounds = true
        
            
            
        }else{
            
            cell.messageLabel.backgroundColor = UIColor.flatBlue()
            cell.messageLabel.layer.cornerRadius = 20
            cell.messageLabel.layer.masksToBounds = true
        }
         //.flatMint()
         
         return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
            //view.frame.size.height/10
    }
    
    
    //dateを文字列に変換するメソッド
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //日時文字列をDate型に変換
    func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        print("sssssssssssssssssss")
        print(string)
        return formatter.date(from: string)!// "2015/03/04 12:34:56 +09:00")!
    }
    
    
    
    @IBAction func sendAction(_ sender: Any) {
        
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        if messageTextField.text!.count > 20{
            
            print("15文字以上です。")
            
            return
            
        }
        
        let chatDB = Database.database().reference().child("chats")
        
        let date : Date = Date()
        let dateString = stringFromDate(date: date,format: "yyyy年MM月dd日 HH時mm分ss秒 Z")
        
        //キーバリュー型で内容を送信（辞書型）
        let messageInfo = ["sender": Auth.auth().currentUser?.email, "receiver": "pochi@gmail.com", "message": messageTextField.text!, "date": dateString]
        
        chatDB.childByAutoId().setValue(messageInfo) { (error, result) in
        if error != nil {
            print(error)
        } else {
         
            print("送信成功")
         
            self.messageTextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextField.text = ""
        }
        }
    }
    
    func fetchChatData() {
        
    //guard let receiver = UserDefaults.standard.object(forKey: toDoString) as? String else {return}
     
 //let notificationArray = [[String:Dictionary<<#Key: Hashable#>, Any>]]()
    //var senDic = ["2020年07月28日 13時49分53秒 +0900": ["message": "test", "sender": "pochi@gmail.com", "receiver": "ponta.gmail.com"]]
    //var dictOfDict: [String: [String:String]]
    //var dictionary: [Date: [String:String] ] = [:]
    var senDic: [Date: [String:String] ] = [:]
    var recDic: [Date: [String:String] ] = [:]
        
    let fetchDataRef = Database.database().reference().child("chats")
        
    fetchDataRef.queryOrdered(byChild: "sender").queryEqual(toValue: Auth.auth().currentUser?.email).observe(.value, with: { snapshot in
    if let user = snapshot.value as? [String : AnyObject] {
    for key in user {
        //print(key.key)
        //let snapShotData = key.value as!AnyObject
        let sender = key.value["sender"]! ??  0
        let receiver = key.value["receiver"]! ??  0
        let text = key.value["message"]! ??  0
        let time = key.value["date"]! ?? 0
        
        //let text = snapShotData.value(forKey: "message")
        //print(receiver as! String, sender as! String)
        let message = Message()
        message.message = text as! String
        message.sender = sender as! String
        self.chatArray.append(message)
        self.tableView.reloadData()
        
        //if (receiver as! String) == "pochi@gmail.com" {
        let data = self.dateFromString(string: (time as! String), format: "yyyy年MM月dd日 HH時mm分ss秒 Z")
        
        print("time")
        print(time)
        print("time as! String")
        print(time as! String)
        
        print((Auth.auth().currentUser?.email)!)
        senDic[data] = ["message": (text as! String), "sender": (Auth.auth().currentUser?.email)!, "receiver": (receiver as! String)]
            
            print(senDic)
            
            
            
            /*let message = Message()
            message.message = text as! String
            message.sender = sender as! String
            self.chatArray.append(message)
            self.tableView.reloadData()*/
            
       // }
        
    }
    }
    })
     
    fetchDataRef.queryOrdered(byChild: "receiver").queryEqual(toValue: Auth.auth().currentUser?.email).observe(.value, with: { snapshot in
    if let user = snapshot.value as? [String : AnyObject] {
        for key in user {
            //print(key.key)
            //let snapShotData = key.value as!AnyObject
            let sender = key.value["sender"]! ??  0
            let receiver = key.value["receiver"]! ??  0
            let text = key.value["message"]! ??  0
            let time = key.value["date"]! ?? 0
            //let text = snapShotData.value(forKey: "message")
            //print(receiver as! String, sender as! String)
            
            let message = Message()
            message.message = text as! String
            message.sender = sender as! String
            self.chatArray.append(message)
            self.tableView.reloadData()
            
            if (sender as! String) == "pochi@gmail.com" {
                let data2 = self.dateFromString(string: (time as! String), format: "yyyy年MM月dd日 HH時mm分ss秒 Z")
                
                recDic[data2] = ["message": text as! String, "sender": receiver as! String , "receiver": (Auth.auth().currentUser?.email)!]
                
            //if (receiver as! String) == Auth.auth().currentUser?.email && (sender as! String) == "ponta@gmail.com" || (sender as! String) == Auth.auth().currentUser?.email && (receiver as! String) == "ponta@gmail.com" {
            }
                /*
                let message = Message()
                message.message = text as! String
                message.sender = sender as! String
                self.chatArray.append(message)
                self.tableView.reloadData()*/
            
        }
        }
        })
        
        
        
        //結合を描くここに///
        
        
        let mergedDictionary = senDic.merging(recDic) { $1 }
        print("マージ")
        print(mergedDictionary.description)
            
       
    /*
    
    let fetchDataRef = Database.database().reference().child("chats")
    fetchDataRef.observe(.childAdded) { (snapShot) in
    
    let snapShotData = snapShot.value as!AnyObject
    let text = snapShotData.value(forKey: "message")
    let sender = snapShotData.value(forKey: "sender")
     
    let message = Message()
    message.message = text as! String
    message.sender = sender as! String
    self.chatArray.append(message)
    self.tableView.reloadData()
     
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

}
