//
//  Network.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import RxSwift
import Moya

class Network<API: TargetType>: MoyaProvider<API> {
    init(plugins: [PluginType] = []) {
        let session = MoyaProvider<API>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        
        super.init(session: session, plugins: plugins)
    }
    
    func request(_ api: API) -> Single<Response> {
        return self.rx.request(api)
            .filterSuccessfulStatusCodes()
    }
}

extension Network {
    func requestObject<T: Codable>(_ target: API, type: T.Type) -> Single<T> {
        return request(target)
            .map(T.self)
    }
    
    func requestArray<T: Codable>(_ target: API, type: T.Type) -> Single<[T]> {
        return request(target)
            .map([T].self)
    }
}
