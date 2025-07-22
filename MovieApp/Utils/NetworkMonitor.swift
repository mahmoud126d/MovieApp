//
//  NetworkMonitor.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    
    @Published var isConnected: Bool = true
    @Published var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: self.queue)
        
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.connectionType = self.getConnectionType(path)
            }
        }
    }

    
    deinit {
        self.monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else {
            return .unknown
        }
    }
    
    
}
