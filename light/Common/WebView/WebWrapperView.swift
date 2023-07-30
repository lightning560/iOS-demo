//
//  WebWrapperView.swift
//  light
//
//  Created by LiangNing on 2023/06/15.
//

import Combine
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let webView: WKWebView

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    private func webView(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // TODO:
        print("navigationAction.request.url1!: \(navigationAction.request.url!)")
        decisionHandler(.allow)
    }

    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {

        print("navigationAction.request.url2!: \(navigationAction.request.url!)")
        decisionHandler(.allow, preferences)
    }

    private func webView(webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // TODO:
        decisionHandler(.allow)
    }
}

extension WebViewNavigationDelegate: WKScriptMessageHandler {
    // 为上面的ViewController实现WKScriptMessageHandler接口
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { // 实现userContentController方法，可以接受js中传来的message
        if message.name == "jscallios" {
            print("JavaScript is sending a message \(message.body)")
        }
    }
}

class WebViewModel: ObservableObject {
    let webView: WKWebView

    private let navigationDelegate: WebViewNavigationDelegate

    let contentController = WKUserContentController() // 创建WKUserContentController
//    let userScript = WKUserScript( //创建WKUserScrip，传入js中要调用的方法
//                source: "ioscalljs()",
//                injectionTime: .atDocumentEnd,
//                forMainFrameOnly: true
//                )
    let preferences = WKPreferences()

    init() {
        navigationDelegate = WebViewNavigationDelegate()

//        contentController.addUserScript(userScript)
//        contentController.add(navigationDelegate, name: "jscallios")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(navigationDelegate, name: "jscallios")
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        configuration.websiteDataStore = .nonPersistent()

        webView = WKWebView(frame: .zero, configuration: configuration)

        webView.navigationDelegate = navigationDelegate
        setupBindings()
    }

    @Published var urlString: String = "http://127.0.0.1:8000/tailwind.html"
//    @Published var urlString: String = "http://127.0.0.1:3000"
//    @Published var urlString: String = "https://apple.com/cn"
    @Published var canGoBack: Bool = true
    @Published var canGoForward: Bool = true
    @Published var isLoading: Bool = true

    private func setupBindings() {
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)

        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)

        webView.publisher(for: \.isLoading)
            .assign(to: &$isLoading)
    }

    func loadUrl() {
        guard let url = URL(string: urlString) else {
            return
        }

        webView.load(URLRequest(url: url))
    }

    func goForward() {
        webView.goForward()
    }

    func goBack() {
        webView.goBack()
    }
}

struct WebWrapperView: View {
    @StateObject var model = WebViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            //            Color.black
            //                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    HStack {
                        TextField("Tap an url",
                                  text: $model.urlString)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .padding(10)
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(30)

                    Button("Go", action: {
                        model.loadUrl()
                    })
                    .foregroundColor(.red)
                    .padding(10)

                }.padding(10)

                HStack {
                    Button(action: {
                        model.goBack()
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.backward")
                    })
                    //                .disabled(!model.canGoBack)

                    Button(action: {
                        model.goForward()
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.right")
                    })
                    //                .disabled(!model.canGoForward)
                    Button("calljs", action: { model.webView.evaluateJavaScript("ioscalljs('这是从Swift传递到JS的参数')") { any, _ in
                        print("ioscalljs-callback")
                        print(any)
//                        print(error)
                    }})
                }

                ZStack {
                    WebView(webView: model.webView)

                    if model.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    model.goBack()
                }, label: {
                    Image(systemName: "arrowshape.turn.up.backward")
                })
                //                .disabled(!model.canGoBack)

                Button(action: {
                    model.goForward()
                }, label: {
                    Image(systemName: "arrowshape.turn.up.right")
                })
                //                .disabled(!model.canGoForward)

                Spacer()
            }
        }
    }
}

struct WebWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WebWrapperView()
    }
}
