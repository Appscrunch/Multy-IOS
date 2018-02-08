//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

extension Date {
    static func defaultGMTDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        return dateFormatter
    }
    
    static func walletAddressGMTDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "dd.MM.yyyy ∙ HH:mm"
        
        return dateFormatter
    }
}
