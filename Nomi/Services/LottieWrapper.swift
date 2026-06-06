//
//  LottieWrapper.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 03/06/26.
//


import SwiftUI
import DotLottie

struct LottieWrapper: UIViewRepresentable {

    let fileName: String
    var loop: Bool = false

    func makeUIView(context: Context) -> UIView {
        let container = UIView()

        let animationView = DotLottieAnimation(
            fileName: fileName,
            config: AnimationConfig(autoplay: true, loop: loop)
        )
        
        let playerView: UIView = animationView.view() as UIView
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(playerView)
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: container.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        animationView.play()
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
