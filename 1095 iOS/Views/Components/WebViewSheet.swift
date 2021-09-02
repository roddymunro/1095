//
//  WebViewSheet.swift
//  Ceramispace
//
//  Created by Roddy Munro on 11/02/2021.
//

import SwiftUI
import RMBarButton
import Combine

struct WebViewSheet: View {
    
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var viewModel = ViewModel()
    @State var showLoader = false
    
    let url: URL
    
    var body: some View {
        NavigationView {
            ZStack {
                WebView(url: url, viewModel: viewModel).overlay (
                    RoundedRectangle(cornerRadius: 4, style: .circular)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                    
                .onReceive(viewModel.showLoader.receive(on: RunLoop.main)) { value in
                    showLoader = value
                }
                
                // A simple loader that is shown when WebView is loading any page and hides when loading is finished.
                if showLoader {
                    ProgressView()
                }
            }
            .navigationBarItems(
                leading: BarButton(iconName: "safari", action: { UIApplication.shared.open(url) }),
                trailing: Button("Close", action: { [presentation] in presentation.wrappedValue.dismiss() })
            )
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    BarButton(iconName: "chevron.left", action: { viewModel.webViewNavigationPublisher.send(.backward) })
                        
                    Spacer()
                    BarButton(iconName: "arrow.clockwise", action: { viewModel.webViewNavigationPublisher.send(.reload) })
                    Spacer()
                    
                    BarButton(iconName: "chevron.right", action: { viewModel.webViewNavigationPublisher.send(.forward) })
                }
            }
        }
    }
}

extension WebViewSheet {
    
    class ViewModel: ObservableObject {
        var webViewNavigationPublisher = PassthroughSubject<WebViewNavigation, Never>()
        var showWebTitle = PassthroughSubject<String, Never>()
        var showLoader = PassthroughSubject<Bool, Never>()
        var valuePublisher = PassthroughSubject<String, Never>()
    }

    // For identifiying WebView's forward and backward navigation
    enum WebViewNavigation {
        case backward, forward, reload
    }
}
