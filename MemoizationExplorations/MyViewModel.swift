//
//  MyViewModel.swift
//  MemoizationExplorations
//
//  Created by Derek Hammond on 8/25/23.
//

import SwiftUI

class MyViewModel: ObservableObject{
   static let backgroundColor: Color = Color(NSColor.controlBackgroundColor)
   
   @Published var counter = 0
   @Published var isPaused = true
   var isTimerActive: Bool { timer?.isValid ?? false }
   @Published private var timer: Timer? // Published to back isTimerActive.
   @Published var videoType: VideoType = .video
   
   enum VideoType: String {
      case gif, video
   }
   
   func startTimer() {
      timer?.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
         guard let self else { return }
         self.counter += 1
      }
   }
   
   func stopTimer() {
      timer?.invalidate()
      timer = nil
   }
}

extension MyViewModel: Equatable {
   static func == (lhs: MyViewModel, rhs: MyViewModel) -> Bool {
      lhs.counter == rhs.counter
      && lhs.isPaused == rhs.isPaused
      && lhs.isTimerActive == rhs.isTimerActive
      && lhs.videoType == rhs.videoType
   }
}
