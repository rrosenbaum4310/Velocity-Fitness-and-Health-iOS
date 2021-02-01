//
//  LWPickerView.swift
//  LynkedWorld
//
//  Created by Macbook on 01/01/18.
//  Copyright © 2018 Arusys. All rights reserved.
//

import UIKit

class LWPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum DateType {
        case month
        case year
        case monthYear
        case string
    }
    
    var type: DateType = .monthYear
    
    
    var months: [String]!
    var years: [Int]!
    fileprivate var inputList = [String]()
    var selectedIndex: Int = 0 {
        didSet {
            if type == .string {
                selectRow(selectedIndex, inComponent: 0, animated: false)
            }
        }
    }
    var month: Int = 0 {
        didSet {
            if type == .year {
                
            } else {
                selectRow(month-1, inComponent: 0, animated: false)
            }
        }
    }
    
    var year: Int = 0 {
        didSet {
            
            if type == .month {
                
            } else if type == .string {
                
            } else if type == .year {
               
                if let index = years.index(of: year) {
                    selectRow(index, inComponent: 0, animated: true)
                } else {
                    selectRow(0, inComponent: 0, animated: true)
                }
                
                
            } else {
                if let index = years.index(of: year) {
                    selectRow(index, inComponent: 1, animated: true)
                } else {
                    selectRow(0, inComponent: 1, animated: true)
                }
                
            }
        }
    }
    
    var onMonthSelected: ((_ month: Int) -> Void)?
    var onYearSelected: ((_ year: Int) -> Void)?
    var onYearSelectedWithController: ((_ picker: LWPickerView,_ year: Int) -> Void)?
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var onInputStringSelected: ((_ index: Int) -> Void)?
    
    init(type: DateType = .monthYear) {
        super.init(frame: .zero)
        self.type = type
        self.commonSetup()
        
    }
    init(type: DateType = .string, input inputList: [String]) {
        super.init(frame: .zero)
        self.inputList = inputList
        self.type = type
        
        self.delegate = self
        self.dataSource = self
        
        self.commonSetup()
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...100 {
                years.append(year)
                year -= 1
            }
        }
        self.years = years
        year = years[0]
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.reloadAllComponents()
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if type == .month {
            return 1
        } else if type == .year {
            return 1
        } else if type == .string {
            return 1
        } else {
            return 2
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if type == .month {
            return months[row]
        } else if type == .year {
            return "\(years[row])"
        } else if type == .string {
            return "\(inputList[row])"
        } else {
            switch component {
            case 0:
                return months[row]
            case 1:
                return "\(years[row])"
            default:
                return nil
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if type == .month {
            return months.count
        } else if type == .year {
            return years.count
        } else if type == .string {
            return inputList.count
        } else {
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if type == .month {
            let month = self.selectedRow(inComponent: 0)+1
            if let block = onMonthSelected {
                block(month)
            }
            self.month = month
        } else if type == .year {
            let year = years[self.selectedRow(inComponent: 0)]
            if let block = onYearSelected {
                block(year)
            }
            
            if let block = onYearSelectedWithController {
                block(self, year)
            }
            
            self.year = year
        } else if type == .string {
            let index = self.selectedRow(inComponent: 0)
            if let block = onInputStringSelected {
                block(index)
            }
            self.selectedIndex = index
        } else {
            let month = self.selectedRow(inComponent: 0)+1
            let year = years[self.selectedRow(inComponent: 1)]
            if let block = onDateSelected {
                block(month, year)
            }
            self.month = month
            self.year = year
        }
    }

}
