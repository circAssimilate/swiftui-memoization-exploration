//
//  WithViewModel.swift
//  MemoizationExplorations
//
//  Created by Derek Hammond on 8/25/23.
//

import SwiftUI

/// A simple higher-order view for SwiftUI View memoization.
///
///```
/// class MyViewModel: ObservableObject{
///    @Published var isPaused = true
///    @Published var videoType: VideoType = .video
///
///    enum VideoType: String {
///       case gif, video
///    }
/// }
///
/// extension MyViewModel: Equatable {
///    static func == (lhs: MyViewModel, rhs: MyViewModel) -> Bool {
///       lhs.isPaused == rhs.isPaused
///       && lhs.videoType == rhs.videoType
///    }
/// }
///
/// struct MyView: View {
///   @ObservedObject var viewModel: MyViewModel
///
///   var body: some View {
///      counterView
///      videoTypeView
///   }
/// 
///   struct IsPausedViewState: Equatable {
///      let isPaused: Bool
///      init(_ state: MyViewModel) {
///         isPaused = state.isPaused
///      }
///   }
///
///   private var isPausedView: some View {
///      WithViewModel(viewModel, IsPausedViewState.init) { state in
///         Text("isPaused: \(state.isPaused)")
///      }
///   }
///
///   struct VideoTypeViewState: Equatable {
///      let videoType: MyViewModel.VideoType
///      init(_ state: MyViewModel) {
///         videoType = state.videoType
///      }
///   }
///
///   private var videoTypeView: some View {
///      WithViewModel(viewModel, VideoTypeViewState.init) { state in
///         Text("videoType: \(state.videoType)")
///      }
///   }
/// }
/// ```
///
struct WithViewModel<Store: Equatable, ReducedState: Equatable, Content: View>: View, Equatable {
   let reducedState: ReducedState
   let content: (ReducedState) -> Content
   
   init(_ store: Store,
        _ reducer: @escaping (Store) -> ReducedState,
        _ content: @escaping (ReducedState) -> Content) {
      self.reducedState = reducer(store)
      self.content = content
   }
   
   var body: some View {
      content(reducedState)
   }
   
   static func ==(lhs: WithViewModel, rhs: WithViewModel) -> Bool {
      return lhs.reducedState == rhs.reducedState
   }
}
