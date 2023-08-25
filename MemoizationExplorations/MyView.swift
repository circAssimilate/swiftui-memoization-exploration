//
//  MyView.swift
//  MemoizationExplorations
//
//  Created by Derek Hammond on 8/25/23.
//

import SwiftUI

struct MyView: View {
   @ObservedObject var viewModel: MyViewModel
   
   init(_ viewModel: MyViewModel) {
      self.viewModel = viewModel
   }
   
   private var time: String {
      Date().formatted(date: .omitted, time: .complete)
   }
   
   var body: some View {
      VStack {
         Text("SwiftUI Memoizations Exploration").font(.title)
         Divider()
         Text("NOT Memoized").font(.title2)
         Divider()
         controlsView
         Divider()
         VStack {
            Text("Memoized").font(.title2)
            Divider()
            isPausedView
            Divider()
            videoTypeView
            Divider()
            comboView
            Divider()
            clockView
         }
      }
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(MyViewModel.backgroundColor)
      .multilineTextAlignment(.center)
   }
   
   private var controlsView: some View {
      VStack {
         TitleView("controlsView", time: time)
         
         VStack(spacing: 0) {
            if viewModel.isTimerActive {
               Button("Stop", action: viewModel.stopTimer)
            } else {
               Button("Start", action: viewModel.startTimer)
            }
            Text("Clock: \(viewModel.counter)")
         }
         
         VStack(spacing: 0) {
            Button("Toggle", action: { viewModel.isPaused.toggle() })
            Text("isPaused: \(String(viewModel.isPaused))")
         }
         
         VStack(spacing: 0) {
            Button("Toggle", action: {
               viewModel.videoType =  viewModel.videoType == .gif ? .video : .gif
            })
            Text("videoType: \(String(describing: viewModel.videoType))")
         }
      }
   }
   
   struct CounterViewState: Equatable {
      let counter: Int
      init(_ state: MyViewModel) {
         counter = state.counter
      }
   }
   
   private var counterView: some View {
      WithViewModel(viewModel, CounterViewState.init) { state in
         VStack {
            TitleView("counterView", time: time)
            Text("counter: \(state.counter)")
         }
      }
   }
   
   struct IsPausedViewState: Equatable {
      let isPaused: Bool
      init(_ state: MyViewModel) {
         isPaused = state.isPaused
      }
   }
   
   private var isPausedView: some View {
      WithViewModel(viewModel, IsPausedViewState.init) { state in
         VStack {
            TitleView("isPausedView", time: time)
            Text("isPaused (subscribed): \(String(describing: state.isPaused))")
         }
      }
   }
   
   struct ViewTypeViewState: Equatable {
      let videoType: MyViewModel.VideoType
      init(_ state: MyViewModel) {
         videoType = state.videoType
      }
   }
   
   private var videoTypeView: some View {
      WithViewModel(viewModel, ViewTypeViewState.init) { state in
         VStack {
            TitleView("videoTypeView", time: time)
            Text("videoType (subscribed): \(String(describing: state.videoType))")
            Text("isPaused (lazy): \(String(describing: viewModel.isPaused))")
            Text("This is considered \"lazy\" because it only picks up viewModel.isPaused when subscribed state changes.")
               .font(.caption)
         }
      }
   }
   
   struct ComboViewState: Equatable {
      let isPaused: Bool
      let videoType: MyViewModel.VideoType
      init(_ state: MyViewModel) {
         isPaused = state.isPaused
         videoType = state.videoType
      }
   }
   
   private var comboView: some View {
      WithViewModel(viewModel, ComboViewState.init) { state in
         VStack {
            TitleView("comboView", time: time)
            Text("isPaused (subscribed): \(String(describing: state.isPaused))")
            Text("videoType (subscribed): \(String(describing: state.videoType))")
         }
      }
   }
   
   struct ClockViewState: Equatable {
      let counter: Int
      init(_ state: MyViewModel) {
         counter = state.counter
      }
   }
   
   private var clockView: some View {
      WithViewModel(viewModel, ClockViewState.init) { state in
         VStack {
            TitleView("clockView", time: time)
            Text("clock (subscribed): \(String(describing: state.counter))")
         }
      }
   }
}

/// View that flashes on time update.
struct TitleView: View {
   let title: String
   let time: String
   
   init(_ title: String, time: String) {
      self.title = title
      self.time = time
   }
   
   @State private var hasPulsed = false
   
   var body: some View {
      HStack(alignment: .firstTextBaseline, spacing: 2) {
         Text("\(title)").font(.headline)
         Text("(last update: \(time))")
            .padding(.horizontal, 3)
            .opacity(hasPulsed ? 0.75 : 1)
            .animation(.spring(response: 0.5, dampingFraction: 0.2), value: hasPulsed)
            .background(hasPulsed ? .red : .clear)
            .animation(.easeInOut(duration: 0.5), value: hasPulsed)
            .onChange(of: time) { _ in
               Task { @MainActor in
                  hasPulsed = true
                  try await Task.sleep(for: .milliseconds(500))
                  hasPulsed = false
               }
         }
      }
      .font(.subheadline)
   }
}

struct MyView_Previews: PreviewProvider {
   static var previews: some View {
      MyView(.init())
         .frame(width: 360, height: 500)
   }
}
