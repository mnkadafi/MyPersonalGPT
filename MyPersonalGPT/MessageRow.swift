//
//  MessageRow.swift
//  MyPersonalGPT
//
//  Created by Mochamad Nurkhayal Kadafi on 07/03/23.
//

import Foundation

struct MessageRow: Identifiable {
  let id = UUID()
  var isInteractingWithChatGPT: Bool
  let sendImage: String
  let sendText: String
  let responseImage: String
  var responseText: String
  var responseError: String?
}
