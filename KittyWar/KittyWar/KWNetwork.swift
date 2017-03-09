//
//  KWNetwork.swift
//  KittyWar
//
//  Created by Hejia Su on 10/20/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import Foundation
import SwiftSocket

// MARK: - Web Server Constants

struct HTTPRequestMethod {
    static let post = "POST"
}

struct WebServerBaseURL {
    static let local  = "http://127.0.0.1:8000/"
    static let remote = "http://www.brucedsu.com:8000/"
}

struct WebServerRequestURL {
    static let register = "kittywar/register/mobile/"
    static let login    = "kittywar/login/mobile/"
}

struct WebServerRequestFormat {
    static let register = "username=%@&password=%@&email=%@"
    static let login    = "username%@&password=%@"
}

struct WebServerStatusCode {
    // register
    static let usernameIsTaken = 409
    static let registerSuccess = 201

    // login
    static let loginSuccess = 200
    static let loginFail    = 400
}

struct WebServerResponseKey {
    static let result   = "result"
    static let token    = "token"
    static let username = "username"
    static let status   = "status"
}

// MARK: - Game Server Constants

struct GameServerURL {
    static let local       = "127.0.0.1"
    static let remote      = "www.brucedsu.com"
    static let port: Int32 = 2056
}

struct GameServerResponse {
    static let headerSize: Int = 4
}

struct GameServerFlag {
    // login & logout
    static let login: UInt8  = 0
    static let logout: UInt8 = 1

    // user profile
    static let userProfile: UInt8  = 3
    static let allCards: UInt8     = 4
    static let catCards: UInt8     = 5
    static let basicCards: UInt8   = 6
    static let chanceCards: UInt8  = 7
    static let abilityCards: UInt8 = 8

    // match flags
    static let findMatch: UInt8              = 2
    static let endMatch: UInt8               = 9
    static let nextPhase: UInt8              = 98
    static let ready: UInt8                  = 99
    static let selectCat: UInt8              = 100
    static let useAbility: UInt8             = 101
    static let opponentCat: UInt8            = 49
    static let gainHP: UInt8                 = 50
    static let opponentGainHP: UInt8         = 51
    static let damageModified: UInt8         = 52
    static let opponentDamageModified: UInt8 = 53
    static let gainChance: UInt8             = 54
    static let opponentGainChance: UInt8     = 55
    static let randomAbility: UInt8          = 56
    static let gainChances: UInt8            = 57
    static let selectMove: UInt8             = 102
    static let selectChance: UInt8           = 103
    static let revealMove: UInt8             = 58
    static let revealChance: UInt8           = 59
}

struct GameServerResponseKey {
    static let flag     = "flag"
    static let bodySize = "bodySize"
    static let body     = "body"
    static let result   = "result"
}

// MARK: - Notification

let registerResultNotification = Notification.Name("registerResultNotification")
let loginResultNotification = Notification.Name("loginResultNotification")
let receivedGameServerResponseNotification =
    Notification.Name("receivedGameServerResponseNotification")
let findMatchResultNotification = Notification.Name("findMatchResultNotification")

enum RegisterResult {
    case usernameIsTaken
    case success
    case failure
}

enum LoginResult {
    case success
    case failure
}

enum FindMatchResult {
    case success
    case failure
}

class KWNetwork: NSObject {

    // MARK: - Properties

    // whether server is running on a local machine
    private static let serversAreRunningLocally = true

    private lazy var gameServer: TCPClient = {
        let gameServer = TCPClient(address: KWNetwork.getGameServerURL(),
                                   port: GameServerURL.port)
        return gameServer
    }()

    private var isConnectedToGameServer = false

    static let shared: KWNetwork = {
        let network = KWNetwork()
        return network
    }()

    // MARK: - Get Web/Game Server (Base) URL

    private static func getWebServerBaseURL() -> String {
        return KWNetwork.serversAreRunningLocally ? WebServerBaseURL.local : WebServerBaseURL.remote
    }

    private static func getGameServerURL() -> String {
        return KWNetwork.serversAreRunningLocally ? GameServerURL.local : GameServerURL.remote
    }

    // MARK: - Initialization

    override init() {

    }

    // MARK: - Webserver Register & Login

    func webServerRegister(username: String, email: String, password: String) {
        // create request
        var request = URLRequest(url: URL(string: KWNetwork.getWebServerBaseURL() + WebServerRequestURL.register)!)
        request.httpMethod = HTTPRequestMethod.post

        // json data
        let jsonDictionary = ["username": username, "password": password, "email": email]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonDictionary,
                                                          options: .prettyPrinted)
        } catch let error as NSError {
            print("JSON error: \(error)")
        }

        // start the session
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check error first
            if error != nil {
                print("Request error: \(error)")
            } else {
                do {
                    let nc = NotificationCenter.default
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    let status = (parsedData[WebServerResponseKey.status] as! NSString).integerValue

                    DispatchQueue.main.async {  // go back to main thread
                        switch status  {
                        case WebServerStatusCode.usernameIsTaken:
                            nc.post(name: registerResultNotification,
                                    object: nil,
                                    userInfo: [WebServerResponseKey.result: RegisterResult.usernameIsTaken])
                        case WebServerStatusCode.registerSuccess:
                            nc.post(name: registerResultNotification,
                                    object: nil,
                                    userInfo: [WebServerResponseKey.result: RegisterResult.success])
                        default:
                            nc.post(name: registerResultNotification,
                                    object: nil,
                                    userInfo: [WebServerResponseKey.result: RegisterResult.failure])
                        }
                    }
                } catch let error as NSError {
                    print("Parsing error: \(error)")
                }
            }
        }.resume()
    }

    func webServerLogin(username: String, password: String) {
        // create request
        var request = URLRequest(url: URL(string: KWNetwork.getWebServerBaseURL() + WebServerRequestURL.login)!)
        request.httpMethod = HTTPRequestMethod.post

        // json data
        let jsonDictionary = ["username": username, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonDictionary,
                                                          options: .prettyPrinted)
        } catch let error as NSError {
            print("JSON error: \(error)")
        }

        // start the session
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check error first
            if error != nil {
                print("Request error: \(error)")
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    let status = (parsedData[ResponseKey.status] as! NSString).integerValue
                    let token: String? = parsedData[ResponseKey.token] as? String

                    DispatchQueue.main.async {  // go back to main thread
                        let nc = NotificationCenter.default

                        switch status  {
                        case WebServerStatusCode.loginSuccess:
                            nc.post(name: loginResultNotification,
                                    object: nil,
                                    userInfo: [WebServerResponseKey.result: LoginResult.success,
                                        WebServerResponseKey.username: username,
                                        WebServerResponseKey.token: token!])
                        case WebServerStatusCode.loginFail:
                            nc.post(name: loginResultNotification,
                                    object: nil,
                                    userInfo: [WebServerResponseKey.result: LoginResult.failure])
                        default:
                            nc.post(name: loginResultNotification,
                                    object: nil,
                                    userInfo: [WebServerResponseKey.result: LoginResult.failure])
                        }
                    }
                } catch let error as NSError {
                    print("Parsing error: \(error)")
                }
            }
        }.resume()
    }

    // MARK: - Parse Game Server Response
    // TODO: This old parse response code is only used by connectToGameServer(). Deprecate in the future.

    enum  BodyType {
        case int
        case string
        case intArray
        case json
    }

    private func parseGameServerResponse(response: [UInt8], bodyType: BodyType) -> (flag: UInt8, sizeOfBody: Int, bodyString: String?, bodyInt: Int?, bodyIntArray: [Int]?) {
        print("Response: \(response)")

        // process flag
        let flag: UInt8 = response[0]
        print("Response flag: \(flag)")

        // data size
        var sizeBytes = response[1...3]
        sizeBytes = [0, 0, 0, 0, 0] + sizeBytes
        let data = Data(bytes: sizeBytes)
        let sizeOfBody = Int(bigEndian: data.withUnsafeBytes { $0.pointee })
        print("Response body size: \(sizeOfBody)")

        var bodyString: String? = nil
        var bodyInt: Int? = nil
        var bodyIntArray: [Int]? = nil

        // process body
        if response.count > 4 {
            switch bodyType {
            case .int:
                bodyInt = Int(response[4])
                print("Response body int: \(bodyInt!)")
            case .string:
                let stringBytes = response[4...response.count - 1]
                let stringData = Data(bytes: stringBytes)
                bodyString = String(data: stringData, encoding: String.Encoding.utf8)
                print("Response body string: \(bodyString!)")
            case .intArray:
                bodyIntArray = [Int]()
                let intArrayBytes = response[4...response.count - 1]
                for intArrayByte in intArrayBytes {
                    bodyIntArray!.append(Int(intArrayByte))
                }
                print("Response int array: \(bodyIntArray!)")
            default:
                break
            }
        }

        return (flag, sizeOfBody, bodyString, bodyInt, bodyIntArray)
    }

    // MARK: - Game Server Request

    // flag (1 byte) + token (24 bytes) + sizeOfData (3 bytes)
    private func getMessagePrefix(flag: UInt8, sizeOfData: Int) -> [UInt8] {
        var result = [UInt8]()

        // insert flag at the beginning
        result.insert(flag, at: 0);

        // append token
        let token = KWUserDefaults.getToken()
        result += DSConvertor.stringToBytes(string: token)

        // append size of data
        let sizeByteArray = DSConvertor.intToByteArray(number: sizeOfData)
        result += sizeByteArray.suffix(3)  // last three bytes

        return result
    }

    // return true if connected to the game server, otherwise return false
    private func connectToGameServer() -> Bool {
        if isConnectedToGameServer {
            return true
        }

        // create login data
        let username = KWUserDefaults.getUsername()
        var bytes = getMessagePrefix(flag: GameServerFlag.login,
                                     sizeOfData: username.characters.count)
        bytes += DSConvertor.stringToBytes(string: username)
        let loginData = Data(bytes: bytes)

        switch gameServer.connect(timeout: 10) {
        case .success:
            switch gameServer.send(data: loginData) {
            case .success:
                guard let response = gameServer.read(1024 * 10) else {
                    return false
                }

                // parse response
                let (flag, sizeOfBody, _, bodyInt, _) =
                    parseGameServerResponse(response: response, bodyType: .int)

                // check response
                if flag == GameServerFlag.login && sizeOfBody == 1 && bodyInt == 1 {  // success
                    isConnectedToGameServer = true
                    print("Connection to game server success!")
                    return true
                } else {  // failure
                    isConnectedToGameServer = false
                    print("Connection to game server failed!")
                    return false
                }
            case .failure (let error):
                print("Authentication failed, error \(error)")
            }
        case .failure (let error):
            print("Connection to game server failed, error: \(error)")
            return false
        }

        return false
    }

    func findMatch() {
        if !connectToGameServer() {
            return
        }

        let bytes = getMessagePrefix(flag: GameServerFlag.findMatch,
                                     sizeOfData: 0)
        let findMatchData = Data(bytes: bytes)

        DispatchQueue(label: "Network Queue").async {
            switch self.gameServer.send(data: findMatchData) {
            case .success:
                print("Successfully sent find match")
            case .failure (let error):
                print("Failed to send find match, error: \(error)")
            }
        }
    }

    func selectCat(catID: Int) {
        if !connectToGameServer() {
            return
        }

        var bytes = getMessagePrefix(flag: GameServerFlag.selectCat,
                                     sizeOfData: 1)
        bytes += DSConvertor.stringToBytes(string: "\(catID)")
        let selectCatData = Data(bytes: bytes)

        DispatchQueue(label: "Network Queue").async {
            switch self.gameServer.send(data: selectCatData) {
            case .success:
                print("Successfully sent select cat \(catID)")
            case .failure (let error):
                print("Failed to send select cat \(catID), error: \(error)")
            }
        }
    }

    func ready() {
        if !connectToGameServer() {
            return
        }

        let bytes = getMessagePrefix(flag: GameServerFlag.ready,
                                     sizeOfData: 0)
        let readyData = Data(bytes: bytes)

        DispatchQueue(label: "Network Queue").async {
            switch self.gameServer.send(data: readyData) {
            case .success:
                print("Successfully sent ready")
            case .failure (let error):
                print("Failed to send ready, error: \(error)")
            }
        }
    }

    func useAbility(abilityID: Int) {
        if !connectToGameServer() {
            return
        }

        var bytes = getMessagePrefix(flag: GameServerFlag.useAbility,
                                     sizeOfData: 1)
        bytes += DSConvertor.stringToBytes(string: "\(abilityID)")
        let useAbilityData = Data(bytes: bytes)

        DispatchQueue(label: "Network Queue").async {
            switch self.gameServer.send(data: useAbilityData) {
            case .success:
                print("Successfully sent use ability \(abilityID)")
            case .failure (let error):
                print("Failed to send use ability \(abilityID), error: \(error)")
            }
        }
    }

    func selectMove(moveID: Int) {
        if !connectToGameServer() {
            return
        }

        var bytes = getMessagePrefix(flag: GameServerFlag.selectMove,
                                     sizeOfData: 1)
        bytes += DSConvertor.stringToBytes(string: "\(moveID)")
        let selectMoveData = Data(bytes: bytes)

        DispatchQueue(label: "Network Queue").async {
            switch self.gameServer.send(data: selectMoveData) {
            case .success:
                print("Successfully sent select move \(moveID)")
            case .failure (let error):
                print("Failed to send select move \(moveID), error: \(error)")
            }
        }
    }

    func selectChanceCard(chanceCardID: Int) {
        if !connectToGameServer() {
            return
        }

        var bytes = getMessagePrefix(flag: GameServerFlag.selectChanceCard,
                                     sizeOfData: 1)
        bytes += DSConvertor.stringToBytes(string: "\(chanceCardID)")
        let selectChanceCardData = Data(bytes: bytes)

        DispatchQueue(label: "Network Queue").async {
            switch self.gameServer.send(data: selectChanceCardData) {
            case .success:
                print("Successfully sent select chance card \(chanceCardID")
            case .failure (let error):
                print("Failed to send select chance card \(chanceCardID), error: \(error)")
            }
        }
    }

    private var startedReadingAndParsingResponses: Bool = false

    private func bytesToInt(bytes: [UInt8]) -> Int {
        if bytes.count > 0 {
            return Int(bytes[0])
        }

        return 0
    }

    private func bytesToString(bytes: [UInt8]) -> String {
        if bytes.count > 0 {
            let stringData = Data(bytes: bytes)
            return String(data: stringData, encoding: String.Encoding.utf8)!
        }

        return ""
    }

    private func bytesToIntArray(bytes: [UInt8]) -> [Int] {
        var intArray = [Int]()

        for byte in bytes {
            intArray.append(Int(byte))
        }

        return intArray
    }

    func startReadingGameServerResponse() {
        if !connectToGameServer() {
            return
        }

        if startedReadingAndParsingResponses {
            return
        }

        startedReadingAndParsingResponses = true

        DispatchQueue(label: "Read and Parse Responses").async {
            while true {
                // read in the header
                guard let header = self.gameServer.read(GameServerResponse.headerSize) else {
                    continue
                }

                // header must at least be of size 4
                if header.count < GameServerResponse.headerSize {
                    continue
                }

                // parse the header
                let flag: UInt8 = header[0]
                print("Response flag: \(flag)")

                // get body size
                var sizeBytes = header[1...3]
                sizeBytes = [0, 0, 0, 0, 0] + sizeBytes
                let data = Data(bytes: sizeBytes)
                let bodySize = Int(bigEndian: data.withUnsafeBytes { $0.pointee })
                print("Response body size: \(bodySize)")

                // read response body
                var body: [UInt8]? = nil
                if bodySize > 0 {
                    body = self.gameServer.read(bodySize)
                }

                DispatchQueue.main.async {
                    switch flag {
                    case GameServerFlag.findMatch:  // handled by find match view controller
                        var findMatchResult = FindMatchResult.failure

                        if bodySize == 1 {  // success
                            findMatchResult = FindMatchResult.success
                        }

                        Notification.default.post(name: findMatchResultNotification,
                                                  object: nil,
                                                  userInfo: [GameServerResponseKey.result: findMatchResult])
                        break
                    default:  // handled by game view controller
                        // create info dictionary
                        let info: [AnyHashable : Any] = [GameServerResponseKey.flag: flag,
                            GameServerResponseKey.bodySize: bodySize,
                            GameServerResponseKey.body: body]

                        // send notification
                        NotificationCenter.default.post(
                            name: receivedGameServerResponseNotification,
                            object: nil,
                            userInfo: info)
                        break
                    }
                }
            }
        }
    }

}

