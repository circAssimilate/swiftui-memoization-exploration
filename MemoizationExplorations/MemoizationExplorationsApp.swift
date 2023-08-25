//
//  MemoizationExplorationsApp.swift
//  MemoizationExplorations
//
//  Created by Derek Hammond on 8/24/23.
//

import SwiftUI

@main
struct MemoizationExplorationsApp: App {
   @StateObject var viewModel = MyViewModel()
   
   var body: some Scene {
      WindowGroup {
         MyView(viewModel)
      }
   }
}
