//
//  NetworkManager.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 02/10/24.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private var taskSubject = PassthroughSubject<NewTask, Never>()
    private var promptSubject = PassthroughSubject<NewPrompt, Never>()
    
    let payloadDatabase: [ String : Any ] = ["id": "newTaskFromServer", "instanciatedOn":"2024-10-15 07:49:49 +0000", "taskId": "1", "taskToBeDone": ["Red", "Quantum Encryption", "Pseudo AIIDS"]]
    
    func getTaskFromServer() {
        
    }
    
    func getPromptFromServer() {
        
    }
    
    func sendDataToServer(data: Data, completion: @escaping (Bool) -> Void) {
        let stringData = data.toString()
        print("data sended to server: \(stringData ?? "empty")")
        completion(true)
    }
    
}
