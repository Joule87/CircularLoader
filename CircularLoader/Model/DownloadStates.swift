//
//  DownloadStates.swift
//  CircularLoader
//
//  Created by Julio Collado on 1/4/20.
//  Copyright © 2020 Julio Collado. All rights reserved.
//

import Foundation

enum DownloadStates: String {
    
    case Start, InProgress, Pause, Completed, Cancel
    
    var description: String {
        switch self {
        case .Start:
            return "Start"
        case .InProgress:
            return "Downloading.."
        case .Pause:
            return "Paused"
        case .Completed:
            return "Completed"
        case .Cancel:
            return "Canceled"
        }
    }
    
}

