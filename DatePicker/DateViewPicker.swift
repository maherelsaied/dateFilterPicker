//
//  DateViewPicker.swift
//  DatePicker
//
//  Created by Maher on 12/3/20.
//

import UIKit

protocol DateShare {
    func share (date : String)
}


class DateViewPicker : UIView {
    
    
    
    
    var clenderView = UIView()
    var monthView = UIView()
    var monthLbl = UILabel()
    let datePicker = UIPickerView()
    var rotationAngle : CGFloat!
    var mydayNum : [String] = []
    var mydayName : [String] = []
    var selectedTimeId : Int = 0
    var dateSelected : String = ""
    var transformeDate = ""
    var dateBackEnd = ""
    var nextMonth = UIButton()
    var previousMonth = UIButton()
    
    var reallySelected = ""
    var delegate : DateShare!
    
    
    // date from and date to like "2020-01-01"
    @IBInspectable
    var dateFrom: String {
        set{
            self.returnDateM.startDate = newValue
        }
        get{
            return self.returnDateM.startDate
        }
    }
    
    @IBInspectable
    var dateTo: String {
        set{
            self.returnDateM.endDate = newValue
        }
        get{
            return self.returnDateM.endDate
        }
    }
    
    var returnDateM = ReturnDate() {
        didSet{
            returnDateM.startDate = dateFrom
            returnDateM.endDate = dateTo
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clenderView.frame = CGRect(x: 0, y: 0, width: self.frame.width  , height: 80)
        self.addSubview(clenderView)
        
        monthView.translatesAutoresizingMaskIntoConstraints = false
        
        monthView.backgroundColor = #colorLiteral(red: 0.802799046, green: 0.9627382159, blue: 1, alpha: 1)
        self.addSubview(monthView)
        NSLayoutConstraint.activate([
            monthView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            monthView.centerYAnchor.constraint(equalTo: self.topAnchor),
            monthView.heightAnchor.constraint(equalToConstant: 30),
            monthView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        ])
        
        monthLbl.frame = CGRect(x: UIScreen.main.bounds.midX - 100   , y: 0, width: 200, height: 30)
        monthLbl.textColor = #colorLiteral(red: 0.3682759404, green: 0.2226734757, blue: 0.7800974846, alpha: 1)
        monthLbl.textAlignment = .center
        self.monthView.addSubview(monthLbl)
        
        
        
        
        
        self.nextMonth.frame = CGRect(x: UIScreen.main.bounds.maxX - 40 , y: 0, width: 30, height: 30)
        self.nextMonth.setImage(#imageLiteral(resourceName: "multimedia-option (1)"), for: .normal)
        nextMonth.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        
        self.previousMonth.frame = CGRect(x: UIScreen.main.bounds.minX + 10 , y: 0, width: 30, height: 30)
        self.previousMonth.setImage(#imageLiteral(resourceName: "multimedia-option (1)"), for: .normal)
        
        
        self.monthView.addSubview(nextMonth)
        self.monthView.addSubview(previousMonth)
        
        
        self.nextMonth.addTarget(self, action: #selector(getNextMonth(sender:)), for: .touchUpInside)
        self.previousMonth.addTarget(self, action: #selector(getPreviousMonth(sender:)), for: .touchUpInside)
        
        
        
        
        createPickerView()
        self.mydayNum = returnDateM.returndayesNumF()
        self.mydayName = returnDateM.returnDayNameF()
        selecytedIndex()
        getDate()
        
    }
    
    
    
    @objc func getNextMonth (sender : UIButton) {
        
        var isoDate = dateSelected
        if isoDate == "" {
            isoDate = returnDateM.returnCurrntdateDay()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ar")
        dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
        let date = dateFormatter.date(from:isoDate)!
        var dateComponent = DateComponents()
        dateComponent.month = 1
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        print(futureDate!)
        let dateString = dateFormatter.string(from: futureDate!)
        for (index , day) in returnDateM.AllDaysFunc().enumerated() {
            if day == dateString {
                // self.datePicker.selectedRow(inComponent: index)
                datePicker.selectRow(index, inComponent: 0, animated: true)
                
            }
        }
        
    }
    
    @objc func getPreviousMonth (sender : UIButton) {
        
        
        var isoDate = dateSelected
        if isoDate == "" {
            isoDate = returnDateM.returnCurrntdateDay()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ar")
        dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
        let date = dateFormatter.date(from:isoDate)!
        var dateComponent = DateComponents()
        dateComponent.month = -1
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        print(futureDate!)
        let dateString = dateFormatter.string(from: futureDate!)
        for (index , day) in returnDateM.AllDaysFunc().enumerated() {
            if day == dateString {
                // self.datePicker.selectedRow(inComponent: index)
                datePicker.selectRow(index, inComponent: 0, animated: true)
                
            }
        }
    }
    
    
    
    func selecytedIndex () {
        for (index , day) in returnDateM.AllDaysFuncF().enumerated() {
            if day == returnDateM.returnCurrntdateDay() {
                // self.datePicker.selectedRow(inComponent: index)
                datePicker.selectRow(index, inComponent: 0, animated: true)
                
            }
        }
    }
    
    
    
    func createPickerView() {
        
        rotationAngle = -90 * (.pi/180)
        
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        datePicker.frame = CGRect(x: 0, y : 16, width: self.clenderView.frame.width , height: self.clenderView.frame.height)
        self.clenderView.addSubview(datePicker)
        
        
    }
    
    
    func getDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "MMMM"
        let outputDate = formatter.string(from: date)
        self.monthLbl.text = outputDate
        
        if self.dateBackEnd == "" {
            let currentday = returnDateM.returnCurrntdateDay()
            self.dateBackEnd = returnDateM.getdateinBackFormate(date12: currentday)
        }
    }
    
    
    
    
    
}


extension DateViewPicker : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return mydayNum.count
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return mydayNum[row]
        
        
    }
    
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        print(returnDateM.AllDaysFuncF()[row])
        
        dateSelected = (returnDateM.AllDaysFuncF()[row])
        //   let datett = (returnDateM.getdateinBackFormate(date12: dateSelected))
        self.transformeDate = dateSelected
        self.dateBackEnd = returnDateM.getdateinBackFormate(date12: dateSelected)
        self.monthLbl.text = returnDateM.returnMounthF()[row]
        
        //  func you use to get data
        
        self.delegate.share(date: dateSelected)
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 100
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 90)
        let day = UILabel()
        day.frame = CGRect(x: 20, y: 25, width: 60, height: 30)
        day.text = mydayNum[row]
        day.textColor = #colorLiteral(red: 0.3682759404, green: 0.2226734757, blue: 0.7800974846, alpha: 1)
        day.font = UIFont(name: "KufyanArabic-Bold", size: 20)
        day.textAlignment = .center
        view.addSubview(day)
        let dayName = UILabel()
        dayName.frame = CGRect(x: 0, y: 45, width: 100, height: 30)
        dayName.text = mydayName[row]
        dayName.textColor = #colorLiteral(red: 0.3682759404, green: 0.2226734757, blue: 0.7800974846, alpha: 1)
        dayName.font = UIFont(name: "KufyanArabic-Bold", size: 20)
        dayName.textAlignment = .center
        view.addSubview(dayName)
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return view
        
    }
    
}
