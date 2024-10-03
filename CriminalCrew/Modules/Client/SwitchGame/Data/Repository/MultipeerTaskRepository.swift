//
//  MultipeerTaskRepository.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//
import Foundation

protocol TaskRepository {
    func sendTaskDataToPeer(taskDone: TaskDone, completion: @escaping (Bool) -> Void)
    // func fetch()
    // func save()
    // func update()
}

class MultipeerTaskRepository: TaskRepository {
    // menggunakan GPGameEventListener
    // randomized data
    // terima data dari server, dengan purpose hearddata
    // hearddata, ngubah data yang diterima jadi payload
    // menjadi validTags
    
    // func representedAsData untuk mengubah entity menjadi data yang bisa dikirim lewat multipeer
    // func broadcast dalam GPGameEventBroadcaster
    func sendTaskDataToPeer(taskDone: TaskDone, completion: @escaping (Bool) -> Void) {
        print("data sent: \(taskDone)")
        let data = taskDone.representedAsData()
        NetworkManager.shared.sendDataToServer(data: data)
        completion(true)
    }
}
