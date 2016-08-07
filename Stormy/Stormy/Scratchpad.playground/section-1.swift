// Playground - noun: a place where people can play

import Foundation
let secondsSinceBirth = NSTimeInterval(1200000000)
var dateOfBirth = NSDate(timeIntervalSince1970: secondsSinceBirth)

let dateFormatter = NSDateFormatter()
dateFormatter.timeStyle = .MediumStyle

var stringDate = dateFormatter.stringFromDate(dateOfBirth)


