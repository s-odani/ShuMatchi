//
//  ProfileViewController.swift
//  ChatApp3
//
//  Created by apeirogon on 2020/07/24.
//  Copyright © 2020 ShunsukeOdani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet var selectYear: UIPickerView!
    @IBOutlet var selectIndustry: UIPickerView!
    
    let dataList = [
        "メーカー", "商社", "金融", "小売", "IT", "マスコミ・広告", "官公庁・公社"
    ]

    let dataList2 = [
        "21卒", "22卒", "23卒", "24卒"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.layer.cornerRadius = 30.0
    
        selectYear.delegate = self
                selectYear.dataSource = self
                selectYear.tag = 1
                selectIndustry.delegate = self
                selectIndustry.dataSource = self
                selectYear.tag = 2

            }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

          // UIPickerViewの列の数
          func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
          }

          // UIPickerViewの行数、リストの数
    func pickerView( _ pickerView: UIPickerView,
                          numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 1{
                return dataList2.count
            } else if pickerView.tag == 2{
                return dataList.count
            } else {
                return dataList2.count
            }
          }

          // UIPickerViewの最初の表示
    func pickerView( _ pickerView: UIPickerView,
                          titleForRow row: Int,
                          forComponent component: Int) -> String? {
              if pickerView.tag == 1{
                  return dataList2[row]
              } else if pickerView.tag == 2{
                  return dataList[row]
              } else {
                  return dataList2[row]
              }

          }
    
    
    @IBAction func done(_ sender: Any) {
            
        
        //ユーザ名をアプリ内に保存
        UserDefaults.standard.set(userNameTextField.text, forKey: "userName")
        
        //アイコンをアプリ内に保存
        let imageData = logoImageView.image?.jpegData(compressionQuality: 0.1)
        UserDefaults.standard.set(imageData, forKey: "userImage")
        
            let userDB = Database.database().reference().child("users")
            
            //guard let industryText = UserDefaults.standard.object(forKey: "industry") as? String else {return}
            
           // guard let ageText = UserDefaults.standard.object(forKey: "age") as? String else {return}
            
            //キーバリュー型で内容を送信（辞書型）
            let userInfo = ["sender": Auth.auth().currentUser?.email, "age": "22卒", "industry": "IT"]
            
            userDB.childByAutoId().setValue(userInfo) { (error, result) in
            if error != nil {
                print(error)
            } else {
                print("送信成功")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        userNameTextField.resignFirstResponder()
    }
    
    
    @IBAction func imageViewTap(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        //アラートを出す
        //カメラ　or アルバムを選択
        showAlert()
    }
    
    func doCamera(){
        
        let sourceType: UIImagePickerController.SourceType = .camera
       //カメラ利用可能かチェック
    if UIImagePickerController.isSourceTypeAvailable(.camera){
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.allowsEditing = true
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func doAlbum(){
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
           //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil{
            
            let selectImage = info[.originalImage] as! UIImage
            UserDefaults.standard.set(selectImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            
            logoImageView.image = selectImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //アラートを作成
    
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか？", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            
            self.doAlbum()
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


