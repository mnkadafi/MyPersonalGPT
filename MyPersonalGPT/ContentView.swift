//
//  ContentView.swift
//  MyPersonalGPT
//
//  Created by Mochamad Nurkhayal Kadafi on 04/03/23.
//

import SwiftUI

struct ContentView: View {
  var apiKey = "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"
  
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      Task {
        let api = ChatGPTAPI(apiKey: apiKey)
        do {
//          let stream = try await api.sendMessageStream(text: "What is Sundar Pichai?")
//          for try await line in stream {
//            print(line)
//          }
          
          let text = try await api.sendMessage(text: "Tolong buatkan 2 paragraf mengenai pengelompokan penyakit")
          print(text)
        } catch {
          print(error.localizedDescription )
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
