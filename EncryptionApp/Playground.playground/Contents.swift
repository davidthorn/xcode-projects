import UIKit

let data = Data([0b01010001 , 0b01010001])

let l: UInt8 = 0x01
let r: UInt8 = 0b1101

let c =  String(l ^ 0x21, radix: 2)

let output = String(data: data , encoding: .utf8)
