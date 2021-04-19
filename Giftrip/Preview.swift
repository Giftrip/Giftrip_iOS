//
//  Preview.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import Foundation

#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiView: UIViewController, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        // 해당 라인에 원하는 ViewController를 인스턴스화 하세요.
        return UIViewController()
    }
}
@available(iOS 13.0, *)
struct ViewControllerRepresentablePreviewProvider: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ViewControllerRepresentable()
                .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
        }

    }
} #endif
