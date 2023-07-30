# Full stack demo-intro

This is a modern full-stack demo developed independently by Leon LiangNing individual .

 In terms of functionality, half of it is a feed and half is e-commerce, referenced from the XiaoHongShu[小红书 – 你的生活指南 on the App Store (apple.com)](https://apps.apple.com/us/app/%E5%B0%8F%E7%BA%A2%E4%B9%A6-%E4%BD%A0%E7%9A%84%E7%94%9F%E6%B4%BB%E6%8C%87%E5%8D%97/id741292507).

## projects

- [Golang-framework kit-demo](https://github.com/lightning560/mio) is named mio
- [Golang Backend microservice-demo](https://github.com/lightning560/go-microservice)
- [SRE & Full chain stress test](https://github.com/lightning560/mio/blob/main/SRE&Test.md)
- [Web-demo](https://github.com/lightning560/Web-demo)
- [iOS-demo](https://github.com/lightning560/iOS-demo)
- [Flutter-demo](https://github.com/lightning560/Flutter-demo)

# iOS-demo

Personal time is limited, focus on the development of golang framework and golang microservice backend.
iOS demo is a semi-finished product, only basic functions have been implemented, details and UI have not been dealt with.

# tech-stack

### MVVM

- Combine
- Codable

### ui

- SwiftUI
- little bit of UIKit

## http

wrap Alamofire

# features

## feed

### infinity gallery

![](/img/Simulator%20Screen%20Recording%20-%20iPhone%2014%20Pro%20-%202023-07-12%20at%2019.57.43.gif)

### image post+comment

![](/img/Simulator%20Screen%20Recording%20-%20iPhone%2014%20Pro%20-%202023-07-12%20at%2020.05.20.gif)

## Short videos

![](/img/Simulator%20Screen%20Recording%20-%20iPhone%2014%20Pro%20-%202023-07-12%20at%2020.39.41.gif)

## message

![](/img/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202023-07-12%20at%2020.55.11.png)

## mall

![](/img/Simulator%20Screen%20Recording%20-%20iPhone%2014%20Pro%20-%202023-07-12%20at%2020.59.02.gif)

### product

![](/img/Simulator%20Screen%20Recording%20-%20iPhone%2014%20Pro%20-%202023-07-12%20at%2021.27.33.gif)

## me

![](/img/Simulator%20Screen%20Recording%20-%20iPhone%2014%20Pro%20-%202023-07-12%20at%2021.30.25.gif)

# implement

## InfiniteMasonry

use GeometryReader get Masonry's height and offset,`@State private var MasonryHeight: CGFloat = 0` record  Height of Masonry,`@State private var MasonryMinY: CGFloat = 0` record MinY of SCREEN_HEIGHT is height of screen

The data request is triggered if `(SCREEN_HEIGHT - MasonryMinY) > MasonryHeight`.

```swift
struct FeedInfiniteMasonryView: View {
    @ObservedObject var feedVM = FeedViewModel()

    @State private var MasonryHeight: CGFloat = 0
    @State private var MasonryMinY: CGFloat = 0

    var body: some View {
        ScrollView {
            FlowLayoutView(
                list: feedVM.postCardsData,
                colums: 2,
                showsIndicators: true,
                spacing: 30
            ) { card in
                FeedMasonryCardView(postCard: card)
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
            .frame(width: SCREEN_WIDTH)

            Text(feedVM.toggleQueryCards.description)

            GeometryReader { proxy -> AnyView in
                let frame = proxy.frame(in: .global)

                DispatchQueue.main.async {
                    MasonryMinY = frame.minY
                    MasonryHeight = proxy.size.height

                    let toggleQueryCards = (SCREEN_HEIGHT - MasonryMinY) > MasonryHeight
                    if feedVM.toggleQueryCards != toggleQueryCards {
                        feedVM.toggleQueryCards = toggleQueryCards
                    }
                }
                return AnyView(
                    Color.clear
                )
            }
        }
        .frame(alignment: .top)
    }
}
```

feedVM.toggleQueryCards is a boolean variable in the ViewModel.
When feedVM.toggleQueryCard changes, it will send a notification through the combine's publisher,
The receiver will call the asynchronous method listPostCard() in the task,
And then get the data through fetchListPostCard().

```swift
    private var cancelable: Set<AnyCancellable> = []
    private var toggleQueryCardsPublisher: AnyPublisher<Bool, Never> {
           $toggleQueryCards
            .print("toggleQueryCardsPublisher:")
            // 每1秒触发一次
            .debounce(for: 1, scheduler: RunLoop.main)
            // 过滤掉前后发出的值相同的通知
            // 连续多次点击，可能会出现模拟器中现在的情况，弹窗无法消失,注释掉过滤相同值通知的方法
            .eraseToAnyPublisher()
    }

    init() {
        toggleQueryCardsPublisher
            .sink { toggle in
                print("toggleQueryCardsPublisher.sink:", toggle.description)
                if toggle {
                    self.xcount = self.xcount + 9
                    Task {
                        await self.listPostCard()
                    }
                }
            }
            .store(in: &cancelable)
    }

    func listPostCard() async {
        do {
            postCardsWrap = try await fetchListPostCard(offset: offset, limit: limit, by: "like", order: "order")
            offset = limit
            postCardsData = postCardsData + (postCardsWrap?.postCards)!
            print(postCardsData.count)
            for c in postCardsWrap!.postCards {
                if isOdd {
                    postCardsDataOdd.append(c)
                } else {
                    postCardsDataEven.append(c)
                }
                isOdd = !isOdd
            }

        } catch {
            Dlog(error)
        }
    }
```

## DebugLog

```swift
import Foundation

public func Dlog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG

        let str = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: "swift", with: "")
        print(">>> \(str)\(methodName)[\(lineNumber)]: \(message)")
    #endif
}
```

## http client

wrap Alamofire

```swift
struct RbHttpTool {    
    static func awaitRequest<T, V>(url: String, method: HTTPMethod, parameters: T, responseType: V.Type) async throws -> NetworkBaseModel<V> where T: Encodable, V: Codable {
        try await withUnsafeThrowingContinuation({ continuation in
            let api = AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: [NetworkConfig.contentType])
                .cURLDescription { _ in
                    Dlog("\n===请求接口的详细信息===")
                    Dlog("url:\(url)")
                    Dlog("params: \(parameters)")
                }
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let model = try JSONDecoder().decode(NetworkBaseModel<V>.self, from: data)
                            // 拦截错误，抛出异常
                            if model.code == 0 {
                                continuation.resume(throwing: APIError.custom(msg: model.message ?? "未知错误 unknow error"))
                                return
                            }
                            continuation.resume(returning: model)
                        } catch {
                            //                            promise(.failure(APIError.custom(msg: error.localizedDescription)))
                            continuation.resume(throwing: error)
                        }

                    case let .failure(error):
                        //                        promise(.failure(APIError.custom(msg: error.localizedDescription)))
                        continuation.resume(throwing: error)
                    }
                }

            api.resume()
        })
    }
}
```

protocol+extension.

Provide default methods for direct use by viewModel.

```swift
import Foundation

protocol FeedRequest {
    func fetchListPostCard(offset: Int, limit: Int, by: String, order: String) async throws -> PostCardsModelWrap
    func fetchPostById(id: String) async throws -> PostModelWrap
}

extension FeedRequest {
    func fetchListPostCard(offset: Int, limit: Int, by: String, order: String) async throws -> PostCardsModelWrap {
        // http://127.0.0.1:9002/v1/feed/cards/0/5/by/order
        let result = try await RbHttpTool.awaitRequest(url: LocalUrl.feed.url + Req.listPostCard.path + "/" + String(offset) + "/" + String(limit) + "/" + by + "/" + order, method: .get, responseType: PostCardsModelWrap.self)
        return result.data!
    }

    func fetchPostById(id: String) async throws -> PostModelWrap {
        let result = try await RbHttpTool.awaitRequest(url: LocalUrl.feed.url + Req.post.path + "/" + id, method: .get, responseType: PostModelWrap.self)
        return result.data!
    }
}
```

### API.swift

extension of enum return url and route parameter

```swift
import Alamofire
import Foundation
import UIKit

enum LocalUrl {
    case user
    case feed
    case comment
    case mall
}

extension LocalUrl {
    var url: String {
        switch self {
        case .user:
            return "http://192.168.1.103:9001/v1/"
        case .feed:
            return "http://192.168.1.103:9002/v1/"
        case .comment:
            return "http://192.168.1.103:9003/v1/"
        case .mall:
            return "http://192.168.1.103:9004/v1/"
        }
    }
}

enum Req {
    case exam(uid: Int, name: String)
    case listPostCard
    case post
    case subject
    case floors
    case replies
}

extension Req {
    // Parameters: http post request
    var parameters: Parameters? {
        var params: Parameters = [:]

        switch self {
        case let .exam(uid, name):
            params["uid"] = uid
            params["name"] = name
        case .listPostCard:
            print(".listPostCard parameters")
        case .post:
            print(".post paramters")
        case .subject:
            print(".subject paramters")
        case .floors:
            print(".floors")
        case .replies:
            print(".replies")
        }
        return params
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        switch self {
        case .exam:
            return "exam/"
        case .listPostCard:
            return "feed/cards"
        case .post:
            return "feed/post"
        case .subject:
            return "comment/subject"
        case .floors:
            return "comment/floors"
        case .replies:
            return "comment/replies"
        }
    }
}
```

wrap Alamofire

```swift
import Alamofire
import Combine
import Foundation

struct RbHttpTool {
    static func awaitRequest<V>(url: String, method: HTTPMethod, responseType: V.Type) async throws -> NetworkBaseModel<V> where V: Codable {
        try await withUnsafeThrowingContinuation({ continuation in
            let api = AF.request(url, method: method)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: [NetworkConfig.contentType])
                .cURLDescription { _ in
                    Dlog("\n=请求接口的详细信息=")
                    Dlog("url:\(url)")
                }
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let model = try JSONDecoder().decode(NetworkBaseModel<V>.self, from: data)
                            Dlog(model)
                            // 拦截错误，抛出异常
                            if model.code != 0 {
                                continuation.resume(throwing: APIError.custom(msg: model.message ?? "未知错误 unknow error"))
                                return
                            }
                            continuation.resume(returning: model)
                        } catch {
                            //                            promise(.failure(APIError.custom(msg: error.localizedDescription)))
                            continuation.resume(throwing: error)
                        }

                    case let .failure(error):
                        //                        promise(.failure(APIError.custom(msg: error.localizedDescription)))
                        continuation.resume(throwing: error)
                    }
                }
            api.resume()
        })
    }
    ...
}
```

## json

Serialisation with Codable,If using ForEach requires Identifiable

`basemodel`

```swift
import Foundation

// MARK: - Cursor

struct CursorModel: Codable {
    let offset, limit: Int
}

// MARK: - Image

struct ImageModel: Codable, Identifiable {
    let id: Int
    let url: String
    let hash, name: String?
    let sizeKB, width, height: Int

    enum CodingKeys: String, CodingKey {
        case id, url, hash, name
        case sizeKB = "size_kb"
        case width, height
    }
}

// MARK: - Video

struct VideoModel: Codable {
    var id: Int?
    var url: String?
    var type: String?
    var cover: ImageModel?
    var hash, name: String?
    var sizeKB, width, height, length: Int?
    var createdAt: Int?
}

// MARK: - Tag

struct TagModel: Codable {
    let tagID: Int
    let name: String
    let bizType: String

    enum CodingKeys: String, CodingKey {
        case tagID = "tag_id"
        case name
        case bizType = "biz_type"
    }
}
```

```swift
import Foundation

// MARK: - Post
struct PostModelWrap:Codable{
    var post :PostModel
}
struct PostModel: Codable {
    var id: String
    var uid: Int
    var title, content: String?
    var createdAt, updatedAt: Int?
    var cover: ImageModel?
    var type: String
    var images : [ImageModel]?
    var video: VideoModel?
    var tags: [TagModel]?
    var state, likeCount, shareCount, favorCount: Int
    var viewCount: Int?
    var commentID: String?
    var authorInfo: UserInfoModel?

    enum CodingKeys: String, CodingKey {
        case id, uid, title, content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cover, type, images, video, tags, state
        case likeCount = "like_count"
        case shareCount = "share_count"
        case favorCount = "favor_count"
        case viewCount = "view_count"
        case commentID = "comment_id"
        case authorInfo = "author_info"
    }
}
```

## Implementation of the display GIF image

swiftui can't display  Images in gif format

```swift
import SwiftUI

public struct RbGIFImage: UIViewRepresentable {
    private let data: Data?
    private let name: String?

    public init(data: Data) {
        self.data = data
        self.name = nil
    }

    public init(name: String) {
        self.data = nil
        self.name = name
    }

    public func makeUIView(context: Context) -> UIGIFImage {
        if let data = data {
            return UIGIFImage(data: data)
        } else {
            return UIGIFImage(name: name ?? "")
        }
    }

    public func updateUIView(_ uiView: UIGIFImage, context: Context) {
        if let data = data {
            uiView.updateGIF(data: data)
        } else {
            uiView.updateGIF(name: name ?? "")
        }
    }
}

public class UIGIFImage: UIView {
    private let imageView = UIImageView()
    private var data: Data?
    private var name: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(name: String) {
        self.init()
        self.name = name
        initView()
    }

    convenience init(data: Data) {
        self.init()
        self.data = data
        initView()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        self.addSubview(imageView)
    }

    func updateGIF(data: Data) {
        updateWithImage {
            UIImage.gifImage(data: data)
        }
    }

    func updateGIF(name: String) {
        updateWithImage {
            UIImage.gifImage(name: name)
        }
    }

    private func updateWithImage(_ getImage: @escaping () -> UIImage?) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = getImage()

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

    private func initView() {
        imageView.contentMode = .scaleAspectFit
    }
}

public extension UIImage {
    class func gifImage(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil)
        else {
            return nil
        }
        let count = CGImageSourceGetCount(source)
        let delays = (0..<count).map {
            // store in ms and truncate to compute GCD more easily
            Int(delayForImage(at: $0, source: source) * 1000)
        }
        let duration = delays.reduce(0, +)
        let gcd = delays.reduce(0, gcd)

        var frames = [UIImage]()
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frame = UIImage(cgImage: cgImage)
                let frameCount = delays[i] / gcd

                for _ in 0..<frameCount {
                    frames.append(frame)
                }
            } else {
                return nil
            }
        }

        return UIImage.animatedImage(with: frames,
                                     duration: Double(duration) / 1000.0)
    }

    class func gifImage(name: String) -> UIImage? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return gifImage(data: data)
    }
}

private func gcd(_ a: Int, _ b: Int) -> Int {
    let absB = abs(b)
    let r = abs(a) % absB
    if r != 0 {
        return gcd(absB, r)
    } else {
        return absB
    }
}

private func delayForImage(at index: Int, source: CGImageSource) -> Double {
    let defaultDelay = 1.0

    let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
    let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
    defer {
        gifPropertiesPointer.deallocate()
    }
    let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
    if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
        return defaultDelay
    }
    let gifProperties = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
    var delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                         Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                                    to: AnyObject.self)
    if delayWrapper.doubleValue == 0 {
        delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                         Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                                    to: AnyObject.self)
    }

    if let delay = delayWrapper as? Double,
       delay > 0 {
        return delay
    } else {
        return defaultDelay
    }
}

struct GIFImageTest: View {
    @State private var imageData: Data? = nil

    var body: some View {
        VStack {
            RbGIFImage(name: "preview")
                .frame(height: 300)
            if let data = imageData {
                RbGIFImage(data: data)
                    .frame(width: 300)
            } else {
                Text("Loading...")
                    .onAppear(perform: loadData)
            }
        }
    }

    private func loadData() {
        let task = URLSession.shared.dataTask(with: URL(string: "https://www.gif.cn/Upload/newsucai/2022-09-01/1204.gif")!) { data, response, error in
            imageData = data
        }
        task.resume()
    }
}


struct GIFImage_Previews: PreviewProvider {
    static var previews: some View {
        GIFImageTest()
    }
}
```

## Extention

### Date

```swift
//  Date+Extension.swift

import Foundation

extension Date {
    /// 获取当前时间戳
    /// - Returns: 当前时间戳
    static func getNowTimeStamp() -> Int {
        let nowDate = Date()
        // 10位数时间戳
        let interval = Int(nowDate.timeIntervalSince1970)
        return interval
    }

    /// 获取当前时间字符串
    /// - Returns: 当前时间戳
    static func getNowTimeString(dateFormat: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let nowDate = Date()
        return dateformatter.string(from: nowDate)
    }

    /// 时间戳转换时间字符串
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    static func getTimeString(timeStamp: Int, dateFormat: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: date)
    }

    /// 日期转Date
    /// - Parameters:
    ///   - timeString: 日期字符串
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: Date
    static func getDate(timeString: String, dateFormat: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let date = dateformatter.date(from: timeString) ?? Date()
        return date
    }

    /// 日期转时间戳
    /// - Parameters:
    ///   - timeString: 日期字符串
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间戳
    static func getTimeStamp(timeString: String, dateFormat: String) -> Int {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let date = getDate(timeString: timeString, dateFormat: dateFormat)
        return Int(date.timeIntervalSince1970)
    }

    /// 时间戳转换时间date
    /// - Parameters:
    ///   - timeStamp: 时间戳
    /// - Returns: date
    static func getDateWith(timeStamp: Int) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        return date
    }

    /// 获取（年，月，日，时，分，秒）
    /// - Returns: （年，月，日，时，分，秒）
    func getTime() -> (String, String, String, String, String, String) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy"
        let y = dateformatter.string(from: self)
        dateformatter.dateFormat = "MM"
        let mo = dateformatter.string(from: self)
        dateformatter.dateFormat = "dd"
        let d = dateformatter.string(from: self)
        dateformatter.dateFormat = "HH"
        let h = dateformatter.string(from: self)
        dateformatter.dateFormat = "mm"
        let m = dateformatter.string(from: self)
        dateformatter.dateFormat = "ss"
        let s = dateformatter.string(from: self)

        return (y, mo, d, h, m, s)
    }

    /// 获取时间字符串
    /// - Parameter dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    func getStringTime(dateFormat: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: self)
    }

    /*
     获取指定的上月下月 Date
      Parameters:
        num -1 上一年  1 下一年
     - Returns: Date
     */
    static func getLastNextMonth(num: Int, curDate: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var lastMonthComps = DateComponents()
        // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
        lastMonthComps.month = num
        guard let newDate = calendar.date(byAdding: lastMonthComps, to: curDate)
        else { return Date() }
        return newDate
    }

    /// 获取指定的上年下年 Date
    /// - Parameters:
    /// num -1 上一年  1 下一年
    /// - Returns: Date
    static func getLastNextYear(num: Int, currentDate: Date) -> Date {
        let curDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var lastMonthComps = DateComponents()
        // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
        lastMonthComps.year = num
        guard let newDate = calendar.date(byAdding: lastMonthComps, to: curDate)
        else { return Date() }
        return newDate
    }
}
```

### String

```swift
import Foundation
import UIKit

// MARK: - 常用功能
extension String {

    /// 去掉首尾空格
    var removeHeadAndTailSpace: String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    /// 去掉首尾空格与换行
    var removeHeadAndTailSpaceNewLine: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 去掉所有空格
    var removeAllSpace: String {

        do {
            let regularExpression = try NSRegularExpression(pattern: "\\s*", options: .caseInsensitive)
            return regularExpression.stringByReplacingMatches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count), withTemplate: "")

        } catch _ {
            return self.replacingOccurrences(of: "　", with: "", options: .literal, range: nil).replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
    }


    /// MD5加密
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }

    /// 生成随机字符串
    ///
    /// - Parameters:
    ///   - count: 生成字符串长度
    ///   - isLetter: false=大小写字母和数字组成，true=大小写字母组成，默认为false
    /// - Returns: String
    static func random(_ count: Int, _ isLetter: Bool = false) -> String {

        var ch: [CChar] = Array(repeating: 0, count: count)
        for index in 0..<count {

            var num = isLetter ? arc4random_uniform(58)+65:arc4random_uniform(75)+48
            if num>57 && num<65 && isLetter==false { num = num%57+48 }
            else if num>90 && num<97 { num = num%90+65 }

            ch[index] = CChar(num)
        }

        return String(cString: ch)
    }
}



// MARK: - 验证
extension String {

    /// 邮箱验证
    func isValidateEmail() -> Bool {
        let emailRegex = "^[a-z0-9A-Z]+[- | a-z0-9A-Z . _]+@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:self)
    }

    /// 电话验证
    func isTelPhone() -> Bool {

        let telRegex1 = "^[0-9]{10}$";
        let telRegex2 = "^[0-9]{3}-[0-9]{3}-[0-9]{4}$";
        let telRegex3 = "^\\([0-9]{3}\\)[0-9]{3}-[0-9]{4}$";
        let telRegex4 = "^\\([0-9]{3}\\)[0-9]{7}$";
        let telRegex5 = "^[0-9]{3}-[0-9]{4}$";
        let telRegex6 = "^[0-9]{3}\\.[0-9]{3}\\.[0-9]{4}$";

        let telTest1 = NSPredicate(format: "SELF MATCHES %@", telRegex1)
        let telTest2 = NSPredicate(format: "SELF MATCHES %@", telRegex2)
        let telTest3 = NSPredicate(format: "SELF MATCHES %@", telRegex3)
        let telTest4 = NSPredicate(format: "SELF MATCHES %@", telRegex4)
        let telTest5 = NSPredicate(format: "SELF MATCHES %@", telRegex5)
        let telTest6 = NSPredicate(format: "SELF MATCHES %@", telRegex6)
        return telTest1.evaluate(with:self)||telTest2.evaluate(with:self)||telTest3.evaluate(with:self)||telTest4.evaluate(with:self)||telTest5.evaluate(with:self)||telTest6.evaluate(with:self)
    }

    /// 是否包含汉字
    func isIncludeChineseIn() -> Bool {

        for (_, value) in self.enumerated() {

            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }

        return false
    }
}


// MARK: - 时间相关
extension String {

    /// 获取当前时间戳（秒）
    static func getNowTimeStamp() -> String {
        //获取当前时间
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前时间戳（毫秒）
    static func getNowTimeMilliStamp() -> String {
        //获取当前时间
        let now = Date()
        //当前时间的时间戳
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }

    /// 获取当前时间
    /// - Parameter dateFormat: 时间格式（如：yyyy-MM-dd HH:mm:ss）
    static func getNowTimeString(dateFormat: String) -> String {
        //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: now)
    }

    /// 时间戳转格式化时间（秒）
    /// - Parameter dateFormat: 时间格式（如：yyyy-MM-dd HH:mm:ss）
    func getTimeString(dateFormat: String) -> String {
        guard let timeStamp = Double(self) else { return "" }
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: date)

    }

    /// 时间戳转格式化时间（毫秒）
    /// - Parameter dateFormat: 时间格式（如：yyyy-MM-dd HH:mm:ss）
    func getMilliTimeString(dateFormat: String) -> String {
        guard let timeStamp = Double(self) else { return "" }
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: date)

    }

}
```

## vertical TabView

In order to achieve a vertical sliding video effect, similar to Tiktok

## Drawer

```swift
import SwiftUI

// MARK: menu
struct MeDrawerMenu: View {
    @Binding var menuWidth: CGFloat
    @Binding var offsetX: CGFloat

    var body: some View {
        Form {
            Section {
            }
            Section {
                drawerItemView(itemImage: "lock", itemName: "账号绑定")
                drawerItemView(itemImage: "gear.circle", itemName: "通用设置")
                drawerItemView(itemImage: "briefcase", itemName: "管理")
            }
            Section {
                drawerItemView(itemImage: "icloud.and.arrow.down", itemName: "版本更新")
                drawerItemView(itemImage: "leaf", itemName: "清理缓存")
                drawerItemView(itemImage: "person", itemName: "关于APP")
            }
        }
        .padding(.trailing, UIScreen.main.bounds.width - menuWidth)
        .edgesIgnoringSafeArea(.all)
        .shadow(color: Color.black.opacity(offsetX != 0 ? 0.1 : 0), radius: 5, x: 5, y: 0)
        .offset(x: offsetX)
        .background(
            Color.black.opacity(offsetX == 0 ? 0.5 : 0)
                .ignoresSafeArea(.all, edges: .vertical)
                .onTapGesture {
                    withAnimation {
                        offsetX = -menuWidth
                    }
                })
    }
}

// MARK: 栏目结构

private struct drawerItemView: View {
    var itemImage: String
    var itemName: String
    var body: some View {
        Button(action: {
        }) {
            HStack {
                Image(systemName: itemImage)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                Text(itemName)
                    .foregroundColor(.black)
                    .font(.system(size: 17))
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }.padding(.vertical, 10)
        }
    }
}

struct MeDrawerWidget_Previews: PreviewProvider {
    static var previews: some View {
        MeDrawerMenu(menuWidth: .constant(250), offsetX: .constant(-250))
    }
}
```

## sheet

Bottom up sheet

```swift
import SwiftUI

struct BottomUpDrawerDemoView: View {
    @State var searchText = ""
    @State var showMaskView: Bool = false

    // 搜索栏
    func topBarMenu() -> some View {
        HStack(spacing: 15) {
            // 直播
            Button(action: {
            }) {
                Image(systemName: "video.square")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }

            TextField("搜索文如秋雨", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding(.leading, 8)
                )

            // 新建发布
            Button(action: {
                withAnimation {
                    self.showMaskView = true
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
        }.padding(.horizontal, 15)
    }

    // 操作功能
    func operateBtnView(image: String, text: String) -> some View {
        Button(action: {
            self.showMaskView = false
        }) {
            VStack(spacing: 15) {
                Image(systemName: image)
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .frame(width: 80, height: 80)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
            }
        }
    }

    var body: some View {
        ZStack {
            VStack {
                topBarMenu()
                Spacer()
            }
            if showMaskView {
                MaskView(showMaskView: $showMaskView)
                SlideOutMenu(showMaskView: $showMaskView)
                    .transition(.move(edge: .bottom))
                    .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0))
            }
        }
    }
}

// MARK: 蒙层

struct MaskView: View {
    @Binding var showMaskView: Bool

    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.black)
        .edgesIgnoringSafeArea(.all)
        .opacity(0.2)
        .onTapGesture {
            self.showMaskView = false
        }
    }
}

// 下拉条
func pullDownBtnView() -> some View {
    Rectangle()
        .foregroundColor(Color(.systemGray4))
        .cornerRadius(30)
        .frame(width: 50, height: 5)
}

// MARK: 底部弹窗

struct SlideOutMenu: View {
    @Binding var showMaskView: Bool
    @State private var offsetY = CGSize.zero
    @State var isAllowToDrag: Bool = false

    // 操作功能
    func operateBtnView(image: String, text: String) -> some View {
        Button(action: {
            self.showMaskView = false
        }) {
            VStack(spacing: 15) {
                Image(systemName: image)
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .frame(width: 80, height: 80)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
            }
        }
    }

    // 关闭按钮
    func closeBtnView() -> some View {
        Button(action: {
            self.showMaskView = false
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 24))
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
    }

    var body: some View {
        VStack {
            Spacer()

            // 构建弹窗视图元素
            VStack {
                // 下拉条
                pullDownBtnView()
                Spacer()
                // 操作按钮
                HStack(spacing: 20) {
                    operateBtnView(image: "magazine.fill", text: "写文章")
                    operateBtnView(image: "doc.plaintext.fill", text: "发post")
                    operateBtnView(image: "book.fill", text: "提问题")
                    operateBtnView(image: "paperplane.fill", text: "传资源")
                }
                Spacer()
                // 关闭按钮
                closeBtnView()
            }

            .padding()
            .frame(maxWidth: .infinity, maxHeight: 320)
            .background(Color.white)
            .cornerRadius(10, antialiased: true)

            .offset(y: isAllowToDrag ? offsetY.height : 0)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // 如果向下拖动
                        if gesture.translation.height > 0 {
                            self.isAllowToDrag = true
                            self.offsetY = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        // 如果拖动位置大于100
                        if (self.offsetY.height) > 100 {
                            self.showMaskView = false
                        } else {
                            self.offsetY = .zero
                        }
                    }
            )
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct BottomUpDrawerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        BottomUpDrawerDemoView()
    }
}
```

## Navigation Tabs

use TabView and one state number

```swift
struct FeedMainTabBarView: View {
    @State private var currentSelectedCategory: Int = 0
    private var categoryNavigateList = ["one", "two", "three", "four"]

    var body: some View {
        NavigationView {
            VStack {
                _feedMainTabBarView(currentSelectedCategory: $currentSelectedCategory)
                FeedMainTabViews(selection: $currentSelectedCategory)
            }.padding()
                .navigationBarTitle("Title", displayMode: .inline)
                .navigationBarItems(
                    leading: Image(systemName: "square.fill"),
                    trailing: Button(action: {}) {
                        Label("Add Folder", systemImage: "magnifyingglass").labelStyle(.iconOnly)
                            .foregroundColor(.black)
                    }
                )
        }
    }
}

struct _feedMainTabBarView: View {
    @Binding var currentSelectedCategory: Int
    ...
}
struct FeedMainTabViews: View {
    /// 轮播滚动又用到TabView
    @Binding var selection: Int

    var body: some View {
        TabView(selection: $selection) {
            FeedMasonryView()
                .tag(0)
            FeedInfiniteMasonryView()
                .tag(1)
            FeedMasonryView()
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.spring(), value: selection)
        .onChange(of: selection, perform: { value in
            print(value)
        })
    }
}
```

## TextField in bottom

a buttom in bottomBar can toggle on TextField,
replyFocused represent TextField display,
@FocusState var focused represent TextField is focus or not.

```swift
// MARK: ReplyEditor 
private struct _replyEditorView: View {
    enum FocusedField: Hashable {
        case reply
    }

    @State var input = ""
    @Binding var replyFocused: Bool
    @FocusState var focused: FocusedField?
    var body: some View {
        HStack {
            TextField("replyEditor:", text: $input, onEditingChanged: getFocus)
                .focused($focused, equals: .reply)
            Text("submit")
        }.background(Color.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focused = .reply
                }
            }
    }

    func getFocus(focused: Bool) {
        print("get focus:\(focused ? "true" : "false")")
        print("isFocused:\(focused)")
        replyFocused = focused
    }
}
```

```swift
private struct _imagePostBottomBarView: View {
    @Binding var replyFocused: Bool
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill().foregroundColor(.white)
            HStack {
                Button(action: {
                    self.replyFocused = !replyFocused
                }) {
                    Text("tell something")
                        .foregroundColor(.gray)
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width - 250, height: 40, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 100.0).foregroundColor(.gray).opacity(0.15))
                Image(systemName: "message").font(.title)
                Image(systemName: "waveform.circle").font(.title)
                Image(systemName: "face.smiling").font(.title)
                Image(systemName: "plus.circle").font(.title)
            }.padding()
        }.frame(height: 50)
    }
}
```

when TextField is displaying, send buttom and mask view can canal TextField

```swift
// MARK: 蒙层
private struct _imagePostMaskView: View {
    @Binding var replyFocused: Bool

    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.black)
        .edgesIgnoringSafeArea(.all)
        .opacity(0.1)
        .onTapGesture {
            self.replyFocused = false
        }
    }
}
```

# video player

```swift
struct PlayerViewController: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = false
        vc.videoGravity = .resizeAspectFill

        return vc
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }

    typealias UIViewControllerType = AVPlayerViewController
}

struct PlayerListView: View {
    @Binding var videos: [TTVideo]
    @Binding var currPlayerIndex: Int
    @StateObject var playerListVM = TTVideoPlayListVM()
    @State var isPlaying: Bool = true
    func playerToggle() {
        print("playerToggle: \(videos[currPlayerIndex].player.timeControlStatus.rawValue)")
        if videos[currPlayerIndex].player.timeControlStatus.rawValue == 2 {
            videos[currPlayerIndex].player.pause()
            isPlaying = false
            return
        }
        if videos[currPlayerIndex].player.timeControlStatus.rawValue == 0 {
            videos[currPlayerIndex].player.play()
            isPlaying = true
            return
        }
        if videos[currPlayerIndex].player.timeControlStatus.rawValue == 1 {
            videos[currPlayerIndex].player.pause()
            isPlaying = false
            return
        }
    }

    var body: some View {
     ...
        }
        .onAppear {
            // 在view显示后，获取第一个video的player
            let player = self.videos[0].player
            // 让player播放video
            player.play()
            // 播放完成后的action设置为none
            player.actionAtItemEnd = .none

            // 监听播放到最后的通知
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videos[0].player.currentItem, queue: .main) { _ in
                // 重置视频播放时间并再次播放
                //player.seek(to: .zero)
                //player.play()
            }
        }
    }
}

struct PlayerScrollView: UIViewRepresentable {
    @Binding var currPlayerIndex: Int
    @Binding var videos: [TTVideo]

    typealias UIViewType = UIScrollView

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        // 隐藏垂直方向的滚动条
        scrollView.showsVerticalScrollIndicator = false
        // 垂直方向总是可以拖拽，即使内容不足以撑满view
        scrollView.alwaysBounceVertical = true
        // 打开分页滚动效果
        scrollView.isPagingEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        // 设置scrollView的代理
        scrollView.delegate = context.coordinator

        // 计算得到内容的大小
        let contentSize = CGSize(width: SCREEN_WIDTH, height: TTVIDEO_HEIGHT * CGFloat(videos.count))
        scrollView.contentSize = contentSize

        // 获取播放视频的list，通过UIHostingController转换成UIViewController
        let playerListView = UIHostingController(rootView: PlayerListView(videos: $videos, currPlayerIndex: $currPlayerIndex))
        playerListView.view.frame = CGRect(origin: .zero, size: contentSize)

        // 把播放视频的list添加到scrollView上
        scrollView.addSubview(playerListView.view)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(playerScrollView: self, currPlayerIndex: $currPlayerIndex)
    }

    // 实现代理
    class Coordinator: NSObject, UIScrollViewDelegate {
        var currPlayerIndex: Binding<Int>
        var currIndex: Int = 0
        var playerScrollView: PlayerScrollView

        init(playerScrollView: PlayerScrollView, currPlayerIndex: Binding<Int>) {
            self.playerScrollView = playerScrollView
            self.currPlayerIndex = currPlayerIndex
        }

        // 监听滚动停止
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let index = Int(scrollView.contentOffset.y / TTVIDEO_HEIGHT)

            if currIndex != index {
                currIndex = index
                currPlayerIndex.wrappedValue = index

                for i in 0 ..< playerScrollView.videos.count {
                    playerScrollView.videos[i].player.seek(to: .zero)
                    playerScrollView.videos[i].player.pause()
                }

                playerScrollView.videos[currIndex].player.play()
                // 播放完成后的action设置为none
                playerScrollView.videos[currIndex].player.actionAtItemEnd = .none

                // 监听播放到最后的通知
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerScrollView.videos[currIndex].player.currentItem, queue: .main) { _ in
                    // 重置视频播放时间并再次播放
//                    self.playerScrollView.videos[self.currIndex].player.seek(to: .zero)
//                    self.playerScrollView.videos[self.currIndex].player.play()
                }
            }
        }
    }
}
```

# Hybrid App

## js invoke swift+swift invoke js

```swift
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

        print("navigationAction.request.url1!: \(navigationAction.request.url!)")
        decisionHandler(.allow)
    }

    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print("navigationAction.request.url2!: \(navigationAction.request.url!)")
        decisionHandler(.allow, preferences)
    }

    private func webView(webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

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

    let preferences = WKPreferences()

    init() {
        navigationDelegate = WebViewNavigationDelegate()

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
```
