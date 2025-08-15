//
//  Storyboards.swift
//  RGB
//
//  Created by Usama on 19/11/2021.
//

import Foundation
import UIKit

enum Boards: String {
    case main = "Main"
    case popups = "Popups"
    case sidemenu = "sidemenu"
    case faqsBoard = "FaqsBoard"
    case chatBoard = "ChatStoryBoard"
    case oldStoryboard = "OldStoryboard"
    case videoStoryBoard = "VideoStoryBoard"
    case profileSubVIewStoryBoard = "ProfileSubVIewStoryBoard"
    case searchStoryBoard = "SearchStoryBoard"
    case orderJourneyStoryBoard = "OrderJourneyStoryBoard"
    case productStoryBoard = "ProductStoryBoard"
    var stortBoard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
}

struct StoryboardScene {
    enum LaunchScreen: StoryboardSceneType {
        static let storyboardName = "LaunchScreen"
    }
    
    enum Main: String, StoryboardSceneType {
        case none

        static let storyboardName = Boards.main.rawValue
        
//        static func instantiateDrawerMenuViewController() -> DrawerMenuViewController {
//            return DrawerMenuViewController.getVC(.main)
//        }
    }
    
}




