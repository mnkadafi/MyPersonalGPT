//
//  ContentView.swift
//  MyPersonalGPT
//
//  Created by Mochamad Nurkhayal Kadafi on 04/03/23.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: apiKey))
  @FocusState var isTextFieldFocused: Bool
  
  var body: some View {
    chatListView
      .navigationTitle("Test ChatGPT")
  }
  
  var chatListView: some View {
    ScrollViewReader { proxy in
      VStack(spacing: 0) {
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(vm.messages) { message in
              MessageRowView(message: message) { message in
                Task { @MainActor in
                  await vm.retry(message: message)
                }
              }
            }
          }
          .onTapGesture {
            isTextFieldFocused = false
          }
        }
        
        Divider()
        bottomView(image: "profile", proxy: proxy)
        Spacer()
      }
      .onChange(of: vm.messages.last?.responseText) { _ in
        scrollToBottom(proxy: proxy)
      }
    }
    .background(colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
  }
  
  func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
    HStack(alignment: .top, spacing: 8) {
      if image.hasPrefix("http"), let url = URL(string: image) {
        AsyncImage(url: url) { image in
          image
            .resizable()
            .frame(width: 30, height: 30)
        } placeholder: {
          ProgressView()
        }
      } else {
        Image(image)
          .resizable()
          .frame(width: 30, height: 30)
      }
      
      TextField("Send message", text: $vm.inputMessage, axis: .vertical)
        .autocorrectionDisabled()
        .textFieldStyle(.roundedBorder)
        .focused($isTextFieldFocused)
        .disabled(vm.isInteractingWithChatGPT)
      
      if vm.isInteractingWithChatGPT {
        DotLoadingView()
          .frame(width: 60, height: 30)
      } else {
        Button {
          Task { @MainActor in
            isTextFieldFocused = false
            scrollToBottom(proxy: proxy)
            await vm.sendTapped()
          }
        } label: {
          Image(systemName: "paperplane.circle.fill")
            .rotationEffect(.degrees(45))
            .font(.system(size: 30))
        }
        .disabled(vm.inputMessage
          .trimmingCharacters(in: .whitespacesAndNewlines)
          .isEmpty)
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 12)
  }
  
  private func scrollToBottom(proxy: ScrollViewProxy) {
    guard let id = vm.messages.last?.id else { return }
    proxy.scrollTo(id, anchor: .bottomTrailing)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ContentView()
    }
  }
}
