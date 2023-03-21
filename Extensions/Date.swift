//
//  Date.swift
//  Vmedia
//
//  Created by kandavel on 21/03/23.
//

import Foundation

enum DateFormat{
    
    case Date                           // 24 07 2014
    case DateWithMonth                  // 24 Jul 2014
    case DateWithFullMonth              // 24 July 2014
    case DateWithDayOfWeek              // Wed 24 Jul 2014
    case Day                            // 01
    case Month                          // July
    case Year                           // 2018
    case DayOfTheWeek                   // Tue
    case Time                           // 12:10 AM
    case Time24Hour                     // 22:10
    case DateTime                       // 24 Jul 2014 12:10 AM
    case DateTime24Hour                 // 24 Jul 2014 22 10
    case Custom(format :String)
    case DateWithYear                   // Jul 24, 2014
    case dateReverseFormat              //2020-04-30 17:12:30
    case dateMonthWithLast2DigitYear    //24 Jul 14
    case dateFormatWithTimeZone
    case dateWTimeZoneFormat           //2021-04-06T18:29:59Z
    
    var value:String{
        switch self {
        case .Date:
            return "dd MM yyyy"
        case .DateWithMonth:
            return "dd-MMM-yyyy"
        case .DateWithFullMonth:
            return "dd MMMM yyyy"
        case .DateWithDayOfWeek:
            return "E dd MMM yyyy"
        case .Day:
            return "dd"
        case .Month:
            return "MM"
        case .Year:
            return "yyyy"
        case .DayOfTheWeek:
            return "E"
        case .Time:
            return (Locale.preferredLanguages[0] == "ja") ? "a hh:mm" : "hh:mm a"
        case .Time24Hour:
            return "HH:mm"
        case .DateTime:
            return "dd-MMM-yyyy hh:mm a"
        case .DateTime24Hour:
            return "dd MMM yyyy HH:mm"
        case .Custom(let format):
            return format
        case .DateWithYear:
            return "MMM dd, yyyy"
        case .dateReverseFormat:
            return "yyyy-MM-dd HH:mm:ss"
        case .dateMonthWithLast2DigitYear:
            return "dd MMM yy"
        case .dateFormatWithTimeZone:
            return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .dateWTimeZoneFormat:
            return "yyyy-MM-dd'T'HH:mm:ss'Z'"
        }
    }
}
extension Date {
    func toString(dateFormat: DateFormat)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat.value
    return dateFormatter.string(from: self)
    }
    
    func getReadableDateStringFromDate(date : Date) -> String {
        let calendar  = Calendar.current
        let dateComponents = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: ((dateComponents) as NSNumber))
        let dateFormatter = DateFormatter()
        dateFormatter.locale  = Locale.init(identifier: "en_US")
        dateFormatter.dateFormat = DateFormat.Custom(format: "MMM").value
        dateFormatter.timeZone = NSTimeZone.local
        let dateString = "\(day!) \(dateFormatter.string(from: date))"
        return dateString
    }
}
public extension Collection where Indices.Iterator.Element == Index {
  subscript (safe index: Index) -> Iterator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

extension String {
    func getDate(formatString:String? = nil) -> Date?{
        let dateFmt = DateFormatter()
        dateFmt.locale  = Locale.init(identifier: "en_US")
        dateFmt.dateFormat = DateFormat.dateWTimeZoneFormat.value
        dateFmt.timeZone = NSTimeZone.local
        var dateFormat:String = "yyyy-MM-dd HH:mm:ss"
        if formatString != nil{
            dateFormat = formatString ?? ""
        }
        dateFmt.dateFormat =  dateFormat
        return dateFmt.date(from: self)
        
    }
}
