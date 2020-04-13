//
//  ViewController.swift
//  MedicineCounterV2
//
//  Created by 大原一倫 on 2019/07/21.
//  Copyright © 2019 oharakazumasa. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var medicineField: UITextField!
    @IBOutlet var countField: UITextField!
    @IBOutlet var suuryouField: UITextField!
    @IBOutlet var suuryouLabel: UILabel!
    @IBOutlet var setumeiLabel: UILabel!
    @IBOutlet var niniLabel: UILabel!
    @IBOutlet var nuriButton: UIButton!
    @IBOutlet var nomiButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var kosuuLabel: UILabel!
    @IBOutlet var tyuuigakjiLabel: UILabel!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var viewnomi: UIView!
    @IBOutlet var notifiButton: UIButton!
    @IBOutlet var nokoriLabel: UILabel!
    @IBOutlet var nokorikoLabel: UILabel!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    
    //////////////////////////////////////////////////////////////////////////////////
    var medicine : [Dictionary<String, String>] = []
    var medicine1 : [Dictionary<String, String>] = []
    var notifiDic : [Dictionary<String,String>] = []
    let saveData = UserDefaults.standard
    let notifiiSaveData = UserDefaults.standard
    let notifiStringSaveData = UserDefaults.standard
    let content = UNMutableNotificationContent()
    let center = UNUserNotificationCenter.current()
    var datePicker: UIDatePicker = UIDatePicker()
    var selectedCell : Int!
    var selectedSection : Int!
    var number1: Int = 0
    var newSetNotifiIde: Int = 0
    var setNotifiIde: Int = 0
    var removeNotifiIde = String()
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        medicineField.delegate = self as? UITextFieldDelegate
        countField.delegate = self as? UITextFieldDelegate
        suuryouField.delegate = self as? UITextFieldDelegate
        
        datePicker.datePickerMode = UIDatePicker.Mode.time
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateTextField.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolBar.setItems([spacelItem, doneItem], animated: true)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func done(){
        dateTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if saveData.array(forKey: "MEDICINE") != nil {
            medicine = saveData.array(forKey: "MEDICINE") as! [Dictionary<String, String>]
        }
        
        if saveData.array(forKey: "MEDICINE1") != nil{
            medicine1 = saveData.array(forKey: "MEDICINE1") as! [Dictionary<String, String>]
        }
        
        if notifiiSaveData.object(forKey: "NOWID") != nil{
            setNotifiIde = notifiiSaveData.object(forKey: "NOWID") as! Int
        }
        
        if notifiStringSaveData.object(forKey: "OLDID") != nil{
             removeNotifiIde = notifiiSaveData.object(forKey: "OLDID") as! String
        }
        
        if saveData.array(forKey: "NTS") != nil{
            notifiDic = saveData.array(forKey: "NTS") as! [Dictionary<String,String>]
        }
        
        //////////////////////////////////////////////////////////////////////////////////
        //cellが一度も選ばれてない状態だと落ちる
        if selectedCell != nil {
            if selectedSection == 0{
                medicineField.text = String(medicine[selectedCell!]["text"]!)
                countField.text = String(medicine[selectedCell!]["count"]!)
                nuriButton.isHidden = true
                viewnomi.isHidden = true
                notifiButton.isHidden = true
            }else if selectedSection == 1{
                if medicine1[selectedCell!]["noti"] == ""{
                    medicineField.text = String(medicine1[selectedCell!]["text"]!)
                    countField.text = String(medicine1[selectedCell!]["count"]!)
                    suuryouField.text = String(medicine1[selectedCell!]["suuryou"]!)
                    dateTextField.isHidden = true
                    tyuuigakjiLabel.isHidden = true
                    niniLabel.isHidden = true
                    nomiButton.isHidden = true
                    setumeiLabel.isHidden = true
                    notifiButton.isHidden = true
                }else if medicine1[selectedCell!]["noti"] != nil{
                    medicineField.text = String(medicine1[selectedCell!]["text"]!)
                    countField.text = String(medicine1[selectedCell!]["count"]!)
                    suuryouField.text = String(medicine1[selectedCell!]["suuryou"]!)
                    dateTextField.text = String(medicine1[selectedCell!]["noti"]!)
                    nomiButton.isHidden = true
                    setumeiLabel.isHidden = true
                    notifiButton.isHidden = true
                }
            }else if selectedSection == 2 {
                medicineField.text = String(notifiDic[selectedCell!]["text"]!)
                dateTextField.text = String(notifiDic[selectedCell!]["noti"]!)
                countField.isHidden = true
                suuryouField.isHidden = true
                nomiButton.isHidden = true
                nuriButton.isHidden = true
                setumeiLabel.isHidden = true
                plusButton.isHidden = true
                minusButton.isHidden = true
                nokoriLabel.isHidden = true
                nokorikoLabel.isHidden = true
                kosuuLabel.isHidden = true
                suuryouLabel.isHidden = true
                niniLabel.isHidden = true
            }
            //////////////////////////////////////////////////////////////////////////////////
            
            // Do any additional setup after loading the view.
        }else{
            plusButton.isHidden = true
            minusButton.isHidden = true
            self.viewnomi.layer.borderColor =  UIColor.black.cgColor
            self.viewnomi.layer.borderWidth = 3
            self.viewnomi.layer.cornerRadius = 30
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectnuri() {
        if selectedCell != nil{
            //編集するとき
            medicine.remove(at: selectedCell!)
            let medicineDictionary = ["text": medicineField.text!, "count": countField.text!, "date": String(gettoday())]
            medicine.append(medicineDictionary)
            saveData.set(medicine, forKey: "MEDICINE")
            let alert = UIAlertController(title: "変更完了", message: "変更が完了しました。",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if selectedCell == nil{
            if countField.text == "" {
                let alert = UIAlertController(title: "エラー", message: "数量を入力してください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let  medicineDictionary = ["text": medicineField.text!, "count": countField.text!, "date": String(gettoday())]
                medicine.append(medicineDictionary)
                saveData.set(medicine, forKey: "MEDICINE")
                let aleat = UIAlertController(title: "保存完了",message: "保存が完了しました",preferredStyle: .alert)
                aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                self.present(aleat, animated: true, completion: nil)
            }
        }
    }
    @IBAction func selectnomi() {
        
        if selectedCell != nil {
            
            if selectedSection == 1 {
                
                if medicine1[selectedCell!]["noti"] != nil{
                    
                    if medicine1[selectedCell!]["noti"] == dateTextField.text!{
                        
                        medicine1.remove(at: selectedCell!)
                        let medicine1Dictionary = ["text": medicineField.text!,"count": countField.text!, "suuryou": suuryouField.text!, "date": String(gettoday()), "noti": dateTextField.text!]
                        medicine1.append(medicine1Dictionary)
                        saveData.set(medicine1, forKey: "MEDICINE1")
                        
                    }else{
                        medicine1.remove(at: selectedCell!)
                            center.removePendingNotificationRequests(withIdentifiers: [removeNotifiIde])
                            let medicine1Dictionary = ["text": medicineField.text!,"count": countField.text!, "suuryou": suuryouField.text!, "date": String(gettoday()), "noti": dateTextField.text!]
                            medicine1.append(medicine1Dictionary)
                            saveData.set(medicine1, forKey: "MEDICINE1")
                            
                            if #available(iOS 10.0, *){
                                let center = UNUserNotificationCenter.current()
                                center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                                    if error != nil{
                                        return
                                    }
                                    
                                    if granted{
                                        DispatchQueue.main.async {
                                            let datePi = self.datePicker.date
                                            let compornents = Calendar.current.dateComponents([.hour, .minute], from: datePi)
                                            let pickhour = compornents.hour!
                                            let pickminute = compornents.minute!
                                            let center = UNUserNotificationCenter.current()
                                            center.delegate = self as? UNUserNotificationCenterDelegate
                                            self.content.title = "\(self.medicineField.text!)の服用時間だよ！"
                                            self.content.body = "薬を飲んでアプリの数量を変更しよう！"
                                            self.content.sound = UNNotificationSound.default
                                            
                                            var notificationTime = DateComponents()
                                            var trigger: UNNotificationTrigger
                                            
                                            notificationTime.hour = pickhour
                                            notificationTime.minute = pickminute
                                            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
                                            
                                            let request = UNNotificationRequest(identifier: String(self.setNotifiIde), content: self.content, trigger: trigger)
                                            
                                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                            self.newSetNotifiIde = self.setNotifiIde + 1
                                            self.notifiiSaveData.set(self.newSetNotifiIde, forKey: "NOWID")
                                            self.notifiStringSaveData.set(String(self.setNotifiIde), forKey: "OLDID")
                                        }
                                    }else{
                                        //                                    let aleat = UIAlertController(title: "エラー",message: "設定で通知を許可してください",preferredStyle: .alert)
                                        //                                    aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                                        //                                    self.present(aleat, animated: true, completion: nil)
                                    }
                                })
                            }else{
                                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                                UIApplication.shared.registerUserNotificationSettings(settings)
                            }
                        }
                    }
                    
                }else{
                medicine1.remove(at: selectedCell!)
                let medicine1Dictionary = ["text": medicineField.text!,"count": countField.text!, "suuryou": suuryouField.text!, "date": String(gettoday())]
                medicine1.append(medicine1Dictionary)
                saveData.set(medicine1, forKey: "MEDICINE1")
                              
            }
            
            let alert = UIAlertController(title: "変更完了", message: "変更が完了しました。",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if selectedCell == nil {
            
            if countField.text == "" {
                let  alert = UIAlertController(title: "エラー", message: "数量を入力してください。",preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated:  true, completion: nil)
                
            } else {
                
                if suuryouField.text == ""{
                    let alert = UIAlertController(title: "エラー", message: "一日の服用数を入力してください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    if dateTextField.text != nil{
                        let  medicine1Dictionary = ["text": medicineField.text!, "count": countField.text!, "suuryou": suuryouField.text!, "date": String(gettoday()), "noti": dateTextField.text!, "time": String(setNotifiIde)]
                        medicine1.append(medicine1Dictionary)
                        saveData.set(medicine1, forKey: "MEDICINE1")
                        let aleat = UIAlertController(title: "保存完了",message: "保存が完了しました",preferredStyle: .alert)
                        aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                        self.present(aleat, animated: true, completion: nil)
                        
                        if #available(iOS 10.0, *){
                            let center = UNUserNotificationCenter.current()
                            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                                if error != nil{
                                    return
                                }
                                
                                if granted{
                                    DispatchQueue.main.async {
                                        let datePi = self.datePicker.date
                                        let compornents = Calendar.current.dateComponents([.hour, .minute], from: datePi)
                                        let pickhour = compornents.hour!
                                        let pickminute = compornents.minute!
                                        let center = UNUserNotificationCenter.current()
                                        center.delegate = self as? UNUserNotificationCenterDelegate
                                        self.content.title = "\(self.medicineField.text!)の服用時間だよ！"
                                        self.content.body = "薬を飲んでアプリの数量を変更しよう！"
                                        self.content.sound = UNNotificationSound.default
                                        
                                        var notificationTime = DateComponents()
                                        var trigger: UNNotificationTrigger
                                        
                                        notificationTime.hour = pickhour
                                        notificationTime.minute = pickminute
                                        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
                                        
                                        let request = UNNotificationRequest(identifier: String(self.setNotifiIde), content: self.content, trigger: trigger)
                                        
                                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                        self.newSetNotifiIde = self.setNotifiIde + 1
                                        self.notifiiSaveData.set(self.newSetNotifiIde, forKey: "NOWID")
                                        self.notifiStringSaveData.set(String(self.setNotifiIde), forKey: "OLDID")
                                    }
                                }else{
//                                    let aleat = UIAlertController(title: "エラー",message: "設定で通知を許可してください",preferredStyle: .alert)
//                                    aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
//                                    self.present(aleat, animated: true, completion: nil)
                                }
                            })
                        }else{
                            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                            UIApplication.shared.registerUserNotificationSettings(settings)
                        }
                    }else{
                        let  medicine1Dictionary = ["text": medicineField.text!, "count": countField.text!, "suuryou": suuryouField.text!, "date": String(gettoday())]
                        medicine1.append(medicine1Dictionary)
                        saveData.set(medicine1, forKey: "MEDICINE1")
                        let aleat = UIAlertController(title: "保存完了",message: "保存が完了しました",preferredStyle: .alert)
                        aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                        self.present(aleat, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @IBAction func selectnoti(){
        if selectedCell != nil{
            if notifiDic[selectedCell!]["noti"] == dateTextField.text!{
                
                notifiDic.remove(at: selectedCell!)
                let  notifiDictionary = ["text": medicineField.text!, "date": String(gettoday()), "noti": dateTextField.text!, "time": String(setNotifiIde)]
                notifiDic.append(notifiDictionary)
                saveData.set(notifiDic, forKey: "NTS")
                let aleat = UIAlertController(title: "保存完了",message: "保存が完了しました",preferredStyle: .alert)
                aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                self.present(aleat, animated: true, completion: nil)
                
            }else{
                
                notifiDic.remove(at: selectedCell!)
                           center.removePendingNotificationRequests(withIdentifiers: [removeNotifiIde])
                           let  notifiDictionary = ["text": medicineField.text!, "date": String(gettoday()), "noti": dateTextField.text!, "time": String(setNotifiIde)]
                           notifiDic.append(notifiDictionary)
                           saveData.set(notifiDic, forKey: "NTS")
                           let aleat = UIAlertController(title: "保存完了",message: "保存が完了しました",preferredStyle: .alert)
                           aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                           self.present(aleat, animated: true, completion: nil)
                           
                           if #available(iOS 10.0, *){
                               let center = UNUserNotificationCenter.current()
                               center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                                   if error != nil{
                                       return
                                   }
                                   
                                   if granted{
                                       DispatchQueue.main.async {
                                           let datePi = self.datePicker.date
                                           let compornents = Calendar.current.dateComponents([.hour, .minute], from: datePi)
                                           let pickhour = compornents.hour!
                                           let pickminute = compornents.minute!
                                           let center = UNUserNotificationCenter.current()
                                           center.delegate = self as? UNUserNotificationCenterDelegate
                                           self.content.title = "\(self.medicineField.text!)の時間だよ！"
                                           self.content.body = "アプリの数量を確認しよう！"
                                           self.content.sound = UNNotificationSound.default
                                           
                                           var notificationTime = DateComponents()
                                           var trigger: UNNotificationTrigger
                                           
                                           notificationTime.hour = pickhour
                                           notificationTime.minute = pickminute
                                           trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
                                           
                                           let request = UNNotificationRequest(identifier: String(self.setNotifiIde), content: self.content, trigger: trigger)
                                           UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                           self.newSetNotifiIde = self.setNotifiIde + 1
                                           self.notifiiSaveData.set(self.newSetNotifiIde, forKey: "NOWID")
                                           self.notifiStringSaveData.set(String(self.setNotifiIde), forKey: "OLDID")
                                       }
                                   }else{
                                       //                                    let aleat = UIAlertController(title: "エラー",message: "設定で通知を許可してください",preferredStyle: .alert)
                                       //                                    aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                                       //                                    self.present(aleat, animated: true, completion: nil)
                                   }
                               })
                           }else{
                               let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                               UIApplication.shared.registerUserNotificationSettings(settings)
                           }
            }
        }else{
            let  notifiDictionary = ["text": medicineField.text!, "date": String(gettoday()), "noti": dateTextField.text!, "time": String(setNotifiIde)]
            notifiDic.append(notifiDictionary)
            saveData.set(notifiDic, forKey: "NTS")
            let aleat = UIAlertController(title: "保存完了",message: "保存が完了しました",preferredStyle: .alert)
            aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
            self.present(aleat, animated: true, completion: nil)
            
            if #available(iOS 10.0, *){
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                    if error != nil{
                        return
                    }
                    
                    if granted{
                        DispatchQueue.main.async {
                            let datePi = self.datePicker.date
                            let compornents = Calendar.current.dateComponents([.hour, .minute], from: datePi)
                            let pickhour = compornents.hour!
                            let pickminute = compornents.minute!
                            let center = UNUserNotificationCenter.current()
                            center.delegate = self as? UNUserNotificationCenterDelegate
                            self.content.title = "\(self.medicineField.text!)の時間だよ！"
                            self.content.body = "アプリの数量を確認しよう！"
                            self.content.sound = UNNotificationSound.default
                            
                            var notificationTime = DateComponents()
                            var trigger: UNNotificationTrigger
                            
                            notificationTime.hour = pickhour
                            notificationTime.minute = pickminute
                            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
                            
                            let request = UNNotificationRequest(identifier: String(self.setNotifiIde), content: self.content, trigger: trigger)
                            
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                            self.newSetNotifiIde = self.setNotifiIde + 1
                            self.notifiiSaveData.set(self.newSetNotifiIde, forKey: "NOWID")
                            self.notifiStringSaveData.set(String(self.setNotifiIde), forKey: "OLDID")
                        }
                    }else{
                        //                                    let aleat = UIAlertController(title: "エラー",message: "設定で通知を許可してください",preferredStyle: .alert)
                        //                                    aleat.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
                        //                                    self.present(aleat, animated: true, completion: nil)
                    }
                })
            }else{
                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
        }
    }
    
    @IBAction func selectplus(){
        var num: String = countField.text!
        var str: String = countField.text!
        var intkazu: Int = Int(num)!
        var intNum: Int = Int(str)!
        
        if selectedSection == 0{
            intNum = intNum + 1
            if intNum >= 3{
                countField.textColor = UIColor.black
            }
            str = String(intNum)
            countField.text = str
            medicine[selectedCell!]["count"] = str
            medicine[selectedCell!]["date"] = String(gettoday())
            saveData.set(medicine, forKey: "MEDICINE")
        }else if selectedSection == 1{
            intkazu = intkazu + 1
            if intkazu >= 10{
                countField.textColor = UIColor.black
            }
            num = String(intkazu)
            countField.text = num
            medicine1[selectedCell!]["count"] = num
            medicine1[selectedCell!]["date"] = String(gettoday())
            saveData.set(medicine1, forKey: "MEDICINE1")
        }
    }
    @IBAction func selectminus(){
        var str: String = countField.text!
        var num: String = countField.text!
        var intkazu: Int = Int(num)!
        var intNum: Int = Int(str)!
        if selectedSection == 0{
            intNum = intNum - 1
            if intNum <= 2{
                countField.textColor = UIColor.red
            }
            str = String(intNum)
            countField.text = str
            medicine[selectedCell!]["count"] = str
            medicine[selectedCell!]["date"] = String(gettoday())
            saveData.set(medicine, forKey: "MEDICINE")
        }else if selectedSection == 1{
            intkazu = intkazu - 1
            if intkazu <= 10 {
                countField.textColor = UIColor.red
            }
            num = String(intkazu)
            countField.text = num
            medicine1[selectedCell!]["count"] = num
            medicine1[selectedCell!]["date"] = String(gettoday())
            saveData.set(medicine1, forKey: "MEDICINE1")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        medicineField.resignFirstResponder()
        countField.resignFirstResponder()
        suuryouField.resignFirstResponder()
        
        
        return true
    }
    func gettoday(format: String = "MM/dd-HH:mm") -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

