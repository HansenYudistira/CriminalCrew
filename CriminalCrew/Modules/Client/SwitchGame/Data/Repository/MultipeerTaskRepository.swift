//
//  MultipeerTaskRepository.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//
import Foundation
import Combine

protocol TaskRepository {
    func sendTaskDataToPeer(taskDone: TaskDone) -> AnyPublisher<Bool, Never>
    func getTaskDataFromPeer(completion: @escaping (TaskDone) -> Void)
    func getPromptDataFromPeer(completion: @escaping (NewPrompt) -> Void)
    // func fetch()
    // func save()
    // func update()
}

class MultipeerTaskRepository: TaskRepository {
    func getPromptDataFromPeer(completion: @escaping (NewPrompt) -> Void) {
        print("mendapatkan prompt dari server")
    }
    
    func getTaskDataFromPeer(completion: @escaping (TaskDone) -> Void) {
        print("mendapatkan task dari server")
    }
    
    // menggunakan GPGameEventListener
    // randomized data
    // terima data dari server, dengan purpose hearddata
    // hearddata, ngubah data yang diterima jadi payload
    // menjadi validTags
    
    // func representedAsData untuk mengubah entity menjadi data yang bisa dikirim lewat multipeer
    // func broadcast dalam GPGameEventBroadcaster
    func sendTaskDataToPeer(taskDone: TaskDone) -> AnyPublisher<Bool, Never> {
        
        print("data sent: \(taskDone)")
        
        let data = taskDone.representedAsData()
        
        return Future { promise in
            NetworkManager.shared.sendDataToServer(data: data) { success in
                promise(.success(success))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
