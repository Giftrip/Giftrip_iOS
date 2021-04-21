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
//            .flatMap {
//                return Single.just($0)
//            }
            .filterSuccessfulStatusCodes()
    }
}
