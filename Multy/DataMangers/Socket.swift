//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import SocketIO

class Socket: NSObject {
    static let shared = Socket()
    
    func start() {
        let manager = SocketManager(socketURL: URL(string: "http://192.168.0.109:6666/socket.io/")!, config: [.log(true), .compress, .forceWebsockets(true), .reconnectAttempts(3), .forcePolling(false)])
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }
            
            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
            }
            
            ack.with("Got your currentAmount", "dude")
        }
        
        socket.connect()
    }
    
    
}
