//
//  ServicesRepository.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/02/2021.
//

import Alamofire
import RealmSwift

protocol URLContructable {
    var domain: String { get }
    var path: String { get }
}

protocol APIInputBase: URLContructable {
    var path: String { get }
    var headers: HTTPHeaders { get }
    var params: Parameters { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var data: Data? { get }
    var returnErrorData: Bool { get }
}

protocol APIOutputBase: class {
    init(response: AFDataResponse<Any>)
    var output: APIResult<Data, APIErrorResult> { get }
}

enum APIResult<T, E> {
    case success(T)
    case failure(E)
}

class APIInput: APIInputBase {
    
    let domain: String
    let path: String
    
    var headers: HTTPHeaders = [
        HTTPHeader(name: "Content-Type", value: "application/json"),
        HTTPHeader(name: "Accept", value: "*/*"),
        HTTPHeader(name: "Accept-Encoding", value: "gzip, deflate, br"),
        HTTPHeader(name: "Connection", value: "keep-alive"),
    ]
    
    var params: Parameters = [:]
    var method: HTTPMethod = .get
    var encoding: ParameterEncoding = URLEncoding.default
    var data: Data?
    var returnErrorData: Bool = false
    
    init(withDomain domain: String, path: String = "", params: Parameters = [:], method: HTTPMethod = .get) {
        if let authorizationToken = AccountManagement.accessToken {
            headers.add(HTTPHeader.authorization(bearerToken: authorizationToken))
        }
        
        self.domain = domain
        self.path = path
        self.params = params
        self.method = method
        self.encoding = (method == .get || method == .delete) ? URLEncoding.default : JSONEncoding.default
    }
    
    init(withDomain domain: String, path: String = "", params: Parameters = [:], method: HTTPMethod = .get, customHeaders: HTTPHeaders = []) {
        for header in customHeaders {
            headers.add(header)
        }
        
        self.domain = domain
        self.path = path
        self.params = params
        self.method = method
        self.encoding = (method == .get || method == .delete) ? URLEncoding.default : JSONEncoding.default
    }
}

class APIOutput: APIOutputBase {
    
    var response: AFDataResponse<Any>
    
    required init(response: AFDataResponse<Any>) {
        self.response = response
    }
    
    var output: APIResult<Data, APIErrorResult> {
        switch response.result {
        case .success:
            if let records = response.data {
                return .success(records)
            } else {
                return .failure(.init())
            }
        case .failure(let error):
            return .failure(.init(code: nil, message: error.localizedDescription))
        }
    }
}

extension URLContructable where Self: APIInputBase {
    
    var url: String {
        return domain + path
    }
}

struct APIErrorResult: Error, BaseModel {
    
    var code: String?
    var message: String = "Error"
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
    
    init(code: String? = nil, message: String = "Error") {
        self.code = code
        self.message = message
    }
    
    init(with code: APIErrorResultCode) {
        self.code = code.code
        self.message = code.description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decodeIfPresent(String.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? "Error"
    }
}

enum APIErrorResultCode {
    case emptyResults
    case captcha
    case custom(String)
    
    var code: String {
        switch self {
        case .emptyResults:
            return "empty"
        case .captcha:
            return "captcha"
        case .custom:
            return "custom"
        }
    }
    
    var description: String {
        switch self {
        case .emptyResults:
            return "Empty results"
        case .captcha:
            return "Captcha incorrect!"
        case .custom(let message):
            return message
        }
    }
}

protocol APIBaseDataResults: BaseModel {
    associatedtype D: BaseModel
    
    var data: D? { get }
    var message: String? { get }
    var error: APIErrorResult { get }
}

protocol APIBaseDataListResults: BaseModel {
    associatedtype D: BaseModel
    
    var datas: [D] { get }
    var message: String? { get }
    var error: APIErrorResult { get }
}

struct APIDataResults<D: BaseModel>: APIBaseDataResults {
    var data: D?
    var message: String?
    var error: APIErrorResult
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(D.self, forKey: .data)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        error = try container.decodeIfPresent(APIErrorResult.self, forKey: .error) ?? APIErrorResult()
    }
}

struct APIDataListResults<D: BaseModel>: APIBaseDataListResults {
    var datas: [D]
    var message: String?
    var error: APIErrorResult

    enum CodingKeys: String, CodingKey {
        case data
        case message
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        datas = try container.decodeIfPresent([D].self, forKey: .data) ?? []
        message = try container.decodeIfPresent(String.self, forKey: .message)
        error = try container.decodeIfPresent(APIErrorResult.self, forKey: .error) ?? APIErrorResult()
    }
    
    func encode(to encoder: Encoder) throws { }
}

class APIServices {
    
    private class func _request<T: APIOutputBase>(input: APIInputBase, output: T.Type, _ completion: @escaping (T) -> Void) {
        AF.request(input.url, method: input.method, parameters: input.params, encoding: input.encoding, headers: input.headers).validate().responseJSON(queue: .main) { response in
            completion(T(response: response))
        }
    }
    
    private class func _upload<T: APIOutputBase>(input: APIInputBase, output: T.Type, completion: @escaping (T) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in input.params {
                if let image = (value as? UIImage) {
                    multipartFormData.append(image.pngData()!, withName: key)
                } else {
                    multipartFormData.append(Data(from: value), withName: key)
                }
                
            }
        }, to: input.url).responseJSON { (response) in
            completion(T(response: response))
        }
    }
    
    class func upload<T: APIBaseDataResults, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: ((APIResult<T, APIErrorResult>) ->())? = nil) {
        APIServices._upload(input: input, output: output) {
            let output = $0.output
            
            switch output {
            case .success(let data):
                do {
                    let result = try T.decode(data: data)
                    completion?(.success(result))
                } catch let error {
                    completion?(.failure(.init(code: nil, message: getDecodeError(error, input))))
                }
            case .failure(let error):
                completion?(.failure(.init(code: nil, message: getErrorDescription(error, input))))
            }
        }
    }
    
    class func request<T: APIBaseDataResults, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: ((APIResult<T, APIErrorResult>) -> ())? = nil) {
        APIServices._request(input: input, output: output) {
            let output = $0.output
            switch output {
            case .success(let data):
                do {
                    let result = try T.decode(data: data)
                    completion?(.success(result))
                } catch let error {
                    completion?(.failure(.init(code: nil, message: getDecodeError(error, input))))
                }
            case .failure(let error):
                completion?(.failure(.init(code: nil, message: getErrorDescription(error, input))))
            }
        }
    }
    
    class func request<T: APIBaseDataListResults, R: APIOutputBase>(input: APIInputBase, output: R.Type, completion: ((APIResult<T, APIErrorResult>) -> ())? = nil) {
        APIServices._request(input: input, output: output) {
            let output = $0.output
            switch output {
            case .success(let data):
                do {
                    let result = try T.decode(data: data)
                    completion?(.success(result))
                } catch let error {
                    completion?(.failure(.init(code: nil, message: getDecodeError(error, input))))
                }
            case .failure(let error):
                completion?(.failure(.init(code: nil, message: getErrorDescription(error, input))))
            }
        }
    }
    
    private class func getDecodeError(_ error: Error, _ input: APIInputBase) -> String {
        return String(describing: error) + " when request \(input.path) API"
    }
    
    private class func getErrorDescription(_ error: APIErrorResult, _ input: APIInputBase) -> String {
        return error.message + " when request \(input.path) API"
    }
}

class RealmServices {
    
    private init() {
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    static let shared = RealmServices()
    
    private let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 1,
        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        }
    )
    
    func get<T: RealmSwift.Object, KeyType>(ofType type: T.Type, forPrimaryKey key: KeyType) -> T? {
        let realm = try? Realm()

        return realm?.object(ofType: type, forPrimaryKey: key)
    }
    
    func getAll<T: RealmSwift.Object>(ofType type: T.Type, ofPredicate predicateString: String? = nil) -> [T] {
        let realm = try? Realm()

        if let filter = predicateString {
            if let result = realm?.objects(type).filter(filter) {
                return Array(result)
            } else {
                return []
            }
        } else {
            if let result = realm?.objects(type) {
                return Array(result)
            } else {
                return []
            }
        }
    }
    
    func create<T: RealmSwift.Object>(_ object: T) {
        let realm = try? Realm()
        
        do {
            try realm?.write {
                realm?.add(object, update: .all)
            }
        } catch {
            post(error)
        }
    }
    
    func create<T: RealmSwift.Object>(_ objects: [T]) {
        let realm = try? Realm()
        
        do {
            try realm?.write {
                realm?.add(objects, update: .all)
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: RealmSwift.Object>(ofType type: T.Type, with uuid: String) {
        let realm = try? Realm()
        
        do {
            try realm?.write {
                let predicate = NSPredicate(format: "uuid == %@", uuid)
                
                if let objDelete = realm?.objects(type).filter(predicate).first {
                    realm?.delete(objDelete)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func deleteAll() {
        let realm = try? Realm()
        
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch {
            post(error)
        }
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: Notification.Name("RealmError"), object: error)
    }
}

extension Decodable {
    
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
    
    static func decode(dictionary: [String: Any]) throws -> Self {
        //let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        
        return try decode(data: data)
    }
    
    static func decodeArray(data: Data) throws -> [Self] {
        let decoder = JSONDecoder()
        return try decoder.decode([Self].self, from: data)
    }
}

protocol BaseModel: Codable {
    
}

extension BaseModel where Self: Hashable {
    static func ==(lhs: Self , rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
