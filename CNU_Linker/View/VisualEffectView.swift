//
//  VisualEffectView.swift
//  CNU_Linker
//
//  Created by Kimyaehoon on 31/08/2021.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}

