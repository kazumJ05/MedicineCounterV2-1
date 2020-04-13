//
//  MainTableViewController.swift
//  MedicineCounterV2
//
//  Created by 大原一倫 on 2019/07/21.
//  Copyright © 2019 oharakazumasa. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationCenter

class MainTableViewController: UITableViewController {
    
    let saveData = UserDefaults.standard
    let notifiStringSaveData = UserDefaults.standard
    let sectiontitle = ["外用薬", "内服薬", "通知のみ"]
    let center = UNUserNotificationCenter.current()
    /////////////////////////////////////////////////
    var medicine : [Dictionary<String,String>] = []
    var medicine1 : [Dictionary<String,String>] = []
    var notifiDic : [Dictionary<String,String>] = []
    var selectCell : Int? = nil
    var selectsection : Int? = nil
    var number1: Int = 0
    var setNotifiIde = String()
    //////////////////////////////////////////////////
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCell = nil
        tableView.register(UINib(nibName: "InformationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "cell")
        table.rowHeight = 83
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if saveData.array(forKey: "MEDICINE") != nil {
            medicine = saveData.array(forKey: "MEDICINE") as! [Dictionary<String, String>]
        }
        if saveData.array(forKey: "MEDICINE1") != nil {
            medicine1 = saveData.array(forKey: "MEDICINE1") as! [Dictionary<String, String>]
        }
        if notifiStringSaveData.object(forKey: "OLDID") != nil{
            setNotifiIde = notifiStringSaveData.object(forKey:"OLDID") as! String
        }
        
        if saveData.array(forKey: "NTS") != nil{
            notifiDic = saveData.array(forKey: "NTS") as! [Dictionary<String,String>]
        }
        
        print(medicine)
        print(medicine1)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectiontitle.count
        // #warning Incomplete implementation, return the number of sections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectiontitle[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return medicine.count
        }else if section == 1{
            return medicine1.count
        }else if section == 2{
            return notifiDic.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                as! InformationTableViewCell
            // 条件を書く
            if indexPath.section == 0{
                // テキストをintへ変換
                let str: String = medicine[indexPath.row]["count"]!
                let intNum: Int = Int(str)!
                cell.medicineLabel.text = medicine[indexPath.row]["text"]
                cell.countLabel.text = medicine[indexPath.row]["count"]
                cell.dayLabel.text = medicine[indexPath.row]["date"]
                cell.notifiHidLabel.isHidden = false
                cell.countLabel.isHidden = false
                cell.nissuuLabel.isHidden = true
                cell.suuryouLabel.isHidden = true
                cell.notifiTiLabel.isHidden = true
                cell.notifiLabel.isHidden = true
                if intNum <= 2 {
                    cell.countLabel.textColor = UIColor.red
                } else {
                    cell.countLabel.textColor = UIColor.black
                }
            }else if indexPath.section == 1{
                let str: String = medicine1[indexPath.row]["count"]!
                let num: String = medicine1[indexPath.row]["suuryou"]!
                let intkazu: Int = Int(num)!
                let intNum: Int = Int(str)!
                let nummer: Int = intNum / intkazu
                cell.medicineLabel.text = medicine1[indexPath.row]["text"]
                cell.countLabel.text = medicine1[indexPath.row]["count"]
                cell.dayLabel.text = medicine1[indexPath.row]["date"]
                cell.suuryouLabel.text = String(intNum / intkazu)
                cell.nissuuLabel.isHidden = false
                cell.countLabel.isHidden = false
                cell.notifiHidLabel.isHidden = false
                if medicine1[indexPath.row]["noti"] == ""{
                    cell.notifiLabel.text = "未設定"
                    cell.countLabel.isHidden = false
                    cell.notifiHidLabel.isHidden = false
                }else if medicine1[indexPath.row]["noti"] != nil{
                    cell.notifiLabel.text = medicine1[indexPath.row]["noti"]
                }
                if intNum <= 14 {
                    cell.countLabel.textColor = UIColor.red
                }else{
                    cell.countLabel.textColor = UIColor.black
                }
                if nummer <= 7{
                    cell.suuryouLabel.textColor = UIColor.red
                }else{
                    cell.suuryouLabel.textColor = UIColor.black
                }
            }else if indexPath.section == 2{
                cell.medicineLabel.text = notifiDic[indexPath.row]["text"]
                cell.dayLabel.text = notifiDic[indexPath.row]["date"]
                cell.notifiLabel.text = notifiDic[indexPath.row]["noti"]
                cell.countLabel.isHidden = true
                cell.nissuuLabel.isHidden = true
                cell.suuryouLabel.isHidden = true
                cell.notifiHidLabel.isHidden = true

            }
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell = indexPath.row
        selectsection = indexPath.section
        if selectCell != nil {
            performSegue(withIdentifier: "toAddView", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        if (segue.identifier == "toAddView") {
            let subVC: ViewController = (segue.destination as? ViewController)!
            subVC.selectedCell = selectCell
            subVC.selectedSection = selectsection
        }
    }
    
    @IBAction func addBtn() {
        selectCell = nil
        performSegue(withIdentifier: "toAddView", sender: nil)
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                medicine.remove(at: indexPath.row)
                
            } else if indexPath.section == 1 {
                if medicine1[indexPath.row]["noti"] != nil{
                    
                    medicine1.remove(at: indexPath.row)
                    center.removePendingNotificationRequests(withIdentifiers: [setNotifiIde])
                    
                }else{
                    medicine1.remove(at: indexPath.row)
                }
            }else if indexPath.section == 2{
                notifiDic.remove(at: indexPath.row)
                center.removePendingNotificationRequests(withIdentifiers: [setNotifiIde])
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            saveData.set(medicine, forKey: "MEDICINE")
            saveData.set(medicine1, forKey: "MEDICINE1")
            saveData.set(notifiDic, forKey: "NTS")
            selectCell = nil
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
