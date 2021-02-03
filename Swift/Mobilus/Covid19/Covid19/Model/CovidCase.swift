//
//  CovidCase.swift
//  Covid19


import Foundation

class CovidCase: NSObject, Codable {
    var id: String?
    var country: String?
    var countryCode: String?
    var province: String?
    var city: String?
    var cityCode: String?
    var lat: Float?
    var lon: Float?
    var confirmed: Int?
    var deaths: Int = 0
    var recovered: Int?
    var active: Int?
    var date: Date = Date()
}
