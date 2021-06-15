//
//  NoticeService.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/15.
//

import RxSwift

protocol NoticeServiceType {
    func getNotice(_ idx: Int) -> Single<Notice>
    func getNotices(_ page: Int, size: Int) -> Single<List<Notice>>
}

final class NoticeService: NoticeServiceType {
    fileprivate let network: Network<GiftripAPI>
    
    init(network: Network<GiftripAPI>) {
        self.network = network
    }
    
    func getNotice(_ idx: Int) -> Single<Notice> {
        return network.requestObject(.getNotice(idx), type: Notice.self)
    }
    
    func getNotices(_ page: Int, size: Int) -> Single<List<Notice>> {
        return network.requestObject(.getNotices(page, size), type: List<Notice>.self)
    }
}
