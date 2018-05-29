//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

protocol Localizable {
    var tableName: String { get }
}

extension Localizable where Self: UIViewController {
    func localize(string: String) -> String {
        return string.localized(tableName: tableName)
    }
}
