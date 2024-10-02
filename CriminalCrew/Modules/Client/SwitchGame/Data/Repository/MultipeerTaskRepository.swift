//
//  MultipeerTaskRepository.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//
import Foundation

protocol TaskRepository {
    func sendTaskDataToPeer(taskData: String, completion: @escaping (Bool) -> Void)
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
    func sendTaskDataToPeer(taskData: String, completion: @escaping (Bool) -> Void) {
        print("data sent: \(taskData)")
        completion(true)
    }
}
