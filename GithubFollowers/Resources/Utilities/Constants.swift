//
//  Constants.swift
//  GithubFollowers
//
//  Created by Edgar Jonas Mesquita da Silva on 29/01/25.
//

import Foundation
import UIKit

enum ScreenSize {
    
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLenght = max(ScreenSize.width, ScreenSize.height)
    static let minLenght = max(ScreenSize.width, ScreenSize.height)
    
}


enum DeviceTypes {
    
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE =  idiom == .phone && ScreenSize.maxLenght == 568.0
    static let isiPhone8SStandard =  idiom == .phone && ScreenSize.maxLenght == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed =  idiom == .phone && ScreenSize.maxLenght == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard =  idiom == .phone && ScreenSize.maxLenght == 736.0
    static let isiPhone8PlusZoomed =  idiom == .phone && ScreenSize.maxLenght == 736.0 && nativeScale < scale
    static let isiPhoneX =  idiom == .phone && ScreenSize.maxLenght == 812.0
    static let isiPhoneXsMaxAndXr =  idiom == .phone && ScreenSize.maxLenght == 896.0
    static let isiPad =  idiom == .pad && ScreenSize.maxLenght >= 1024.0
    
    static func isiPhoneXSpectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
    
}


class SFSymbols {
    
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
    
}
