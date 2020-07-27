//
//  ProfileViewController.swift
//  ChatApp3
//
//  Created by apeirogon on 2020/07/24.
//  Copyright © 2020 ShunsukeOdani. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    
        selectYear.delegate = self
                selectYear.dataSource = self
                selectYear.tag = 1
                selectIndustry.delegate = self
                selectIndustry.dataSource = self
                selectYear.tag = 2

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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


