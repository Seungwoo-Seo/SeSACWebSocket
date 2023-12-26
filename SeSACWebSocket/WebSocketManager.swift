//
//  WebSocketManager.swift
//  SeSACWebSocket
//
//  Created by 서승우 on 2023/12/26.
//

import Foundation
import Combine

final class WebSocketManager: NSObject {
    static let shared = WebSocketManager()

    private override init() {
        super.init()
    }

    private var timer: Timer? // 5초마다 ping을 하기 위해 생성
    private var webSocket: URLSessionWebSocketTask?

    private var isOpen = false // 소켓 연결 상태

    // RxSwift PublishSubject vs Combine PassthroughSubject
    // RxSwift BehaviorSubject vs Combine CurrentValueSubject
    // RxSwift 데이터 타입만 설정 vs Combine 데이터 타입 + 오류 타입 함께 지정
    var orderBookSbj = PassthroughSubject<OrderBookWS, Never>()

    func openWebSocket() {
        print(#function)
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

            webSocket = session.webSocketTask(with: url)
            webSocket?.resume()

            ping()
        }
    }

    func closeWebSocket() {
        print(#function)
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil

        timer?.invalidate()
        timer = nil
        isOpen = false
    }

    // 소켓 연결 이 후 send 통해서 원하는 데이터를 받기 위해 서버에게 보냄
    func send() {
        let string = """
[{"ticket":"test"},{"type":"ticker","codes":["KRW-BTC"]}]
"""
        webSocket?.send(.string(string), completionHandler: { error in
            print("send error, ", error?.localizedDescription)
        })
    }
  
    func receive() {
        if isOpen {
            webSocket?.receive(completionHandler: { [weak self] (result) in
                switch result {
                case .success(let success):
                    print("receive success ✅", success)
                    switch success {
                    case .data(let data):

                        if let decodedData = try? JSONDecoder().decode(OrderBookWS.self, from: data) {
                            print("recevie \(decodedData)")

                            self?.orderBookSbj.send(decodedData)
                        }

                    case .string(let string):
                        print(string)
                    @unknown default: print("unknown Error")
                    }
                case .failure(let error):
                    print("receive error ❌", error.localizedDescription)
                    self?.closeWebSocket()
                }
                self?.receive()
            })
        }
    }

    // 서버에 의해 연결이 끊어지지 않도록 주기적으로 ping을 서버에 보냄
    private func ping() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] (timer) in
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error {
                    print("Ping Pong Error")
                } else {
                    print("Ping")
                }
            })
        })
    }

}

extension WebSocketManager: URLSessionWebSocketDelegate {

    // didOpen: 웹소켓 연결이 되었는 지 확인
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        print("WebSocket OPEN")
        isOpen = true
        receive()
    }

    // didClose: 웹소켓이 연결 해제되었는 지 확인
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        isOpen = false
        print("WebSocket CLOSE")
    }

}
