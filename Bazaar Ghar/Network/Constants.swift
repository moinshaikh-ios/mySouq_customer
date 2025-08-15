
import Foundation 
import UIKit
enum SenderType: String {
  case dealer = "Dealer"
  case support = "AAV Support"
  var backgroundColor : UIColor {
    switch self {
    case .dealer:
      return UIColor.init(hexString: "F2994A").withAlphaComponent(0.25)
    case .support:
      return UIColor.init(hexString: "2F80ED").withAlphaComponent(0.25)
    }
  }
  var textColor : UIColor {
    switch self {
    case .dealer:
      return UIColor.init(hexString: "F2994A")
    case .support:
      return UIColor.init(hexString: "2F80ED")
    }
  }
}
enum NetworkEnvironment {
  case live
  case staging
  case prod
  case local
  case stagemysouq
}
struct AppConstants {
  static let gcmMessageIDKey = ""
  static let PRODUCT_ID: Int = 2
  struct API{
      static let environment: NetworkEnvironment = .prod
    static var baseURL: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://apid.bazaarghar.com/v1/")!
        case .staging:
          return URL(string: "https://apix-stage.bazaarghar.com/v1/")! 
      case .prod:
          return URL(string: "https://api.mysouq.com/v1")!
      case.local:
          return URL(string: "http://192.168.1.23:3000/v1/")!
      case.stagemysouq:
          return URL(string: "https://api-stage.mysouq.com/v1/")!

        }
    }
      static var baseURLV2: URL {
        switch AppConstants.API.environment{
          case .live:
            return URL(string: "https://apid.bazaarghar.com/v2/")!
          case .staging:
            return URL(string: "https://apix-stage.bazaarghar.com/v2/")!
        case .prod:
            return URL(string: "https://api.mysouq.com/v2")!
        case.local:

          
          return URL(string: "http://192.168.1.23:3000/v2/")!
        case.stagemysouq:

          
          return URL(string: "https://api-stage.mysouq.com/v2/")!
    
        }
      }
      
      static var videoShareURl: URL {
        switch AppConstants.API.environment{
          case .live:
            return URL(string: "https://d.bazaarghar.com/video/")!
          case .staging:
            return URL(string: "https://stage.bazaarghar.com/video/")!
         case .prod:
            return URL(string: "https://mysouq.com/video/")!
         case.local:return URL(string: "http://192.168.1.23:3000/")!
        case.stagemysouq:
            return URL(string: "https://api-stage.mysouq.com/video/")!


        
          
        }
      }
      static var productShareURl: URL {
        switch AppConstants.API.environment{
          case .live:
            return URL(string: "https://d.bazaarghar.com/product/")!
          case .staging:
            return URL(string: "https://stage.bazaarghar.com/product/")!
         case .prod:
            return URL(string: "https://mysouq.com/product/")!
         case.local:

          
          return URL(string: "http://192.168.1.23:3000/")!
        case.stagemysouq:

          
          return URL(string: "https://api-stage.mysouq.com/product/")!

       
          
          
        }
      }
      static var storeShareURl: URL {
        switch AppConstants.API.environment{
          case .live:
            return URL(string: "https://d.bazaarghar.com/store/")!
          case .staging:
            return URL(string: "https://stage.bazaarghar.com/store/")!
         case .prod:
            return URL(string: "https://mysouq.com/store/")!
         case.local:
          return URL(string: "http://192.168.1.23:3000/")!
        case.stagemysouq:
          return URL(string: "https://api-stage.mysouq.com/store/")!
        

        }
      }
      
//    static var typeSenseUrl: URL {
//       switch AppConstants.API.environment{
//        case .live:
//         return URL(string: "https://search.bazaarghar.com/multi_search?x-typesense-api-key=EeWttEyOdPY8OjKA0E6ayaSWHuyaS8yd")!
//        case .staging:
//        //return URL(string: "http://192.168.1.23:3003/chat/v1/message")!
//        return URL(string: "https://search.bazaarghar.com/multi_search?x-typesense-api-key=RCWZ1ftzaBXQ3wjXwvT5velUhQJJlfdn")!
//       case.local:
//        return URL(string: "https://search.bazaarghar.com/multi_search?x-typesense-api-key=RCWZ1ftzaBXQ3wjXwvT5velUhQJJlfdn")!
//       }
//      }
    static var baseURLSearchProduct: URL {
      switch AppConstants.API.environment{
      case .live:
        return URL(string: "https://apid.bazaarghar.com/v2/")!
      case .staging:
        return URL(string: "https://apix-stage.bazaarghar.com/v2/")! 
      case .prod:
        return URL(string: "https://api.mysouq.com/v2/")!
      case.local:

        return URL(string: "http://192.168.1.23:3000/v2/")!
      case.stagemysouq:
        return URL(string: "https://api-stage.mysouq.com/v2/")!
      
      }
    }
    static var baseURLVideoStreaming: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://apid.bazaarghar.com/streaming/v1/")!
        case .staging:
          return URL(string: "https://apix-stage.bazaarghar.com/streaming/v1/")!
//          return URL(string: "http://192.168.1.23:3002/streaming/v1/")!
          
      case .prod:
          return URL(string: "https://api.mysouq.com/streaming/v1/")!
      case.local:

        
        return URL(string: "http://192.168.1.23:3002/streaming/v1/")!
      case.stagemysouq:
        return URL(string: "https://api-stage.mysouq.com/streaming/v1/")!
     
      }
    }
      static var baseURLVideoStreamingSocket: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://apid.bazaarghar.com/streaming/v1/")!
        case .staging:
          return URL(string: "https://apix-stage.bazaarghar.com/streaming/v1/")!
//          return URL(string: "http://192.168.1.23:3002/streaming/v1/")!
          
      case .prod:
          return URL(string: "https://video-api.mysouq.com")!
      case.local:

        
        return URL(string: "http://192.168.1.23:3002/streaming/v1/")!
      case.stagemysouq:
        return URL(string: "https://api-stage.mysouq.com/streaming/v1/")!
     
      }
    }
      
      static var baseURLVideoStreamingV2: URL {
        switch AppConstants.API.environment{
          case .live:
            return URL(string: "https://apid.bazaarghar.com/streaming/v2/")!
          case .staging:
            return URL(string: "https://apix-stage.bazaarghar.com/streaming/v2/")!
  //          return URL(string: "http://192.168.1.23:3002/streaming/v1/")!
            
        case .prod:
            return URL(string: "https://api.mysouq.com/streaming/v2/")!
        case.local:

          
          return URL(string: "http://192.168.1.23:3002/streaming/v2/")!
        case.stagemysouq:
          return URL(string: "https://api-stage.mysouq.com/streaming/v2/")!

        

          
          
        }
      }
      static var baseURLVideoStreamingV1: URL {
        switch AppConstants.API.environment{
          case .live:
            return URL(string: "https://apid.bazaarghar.com/streaming/v1/")!
          case .staging:
            return URL(string: "https://apix-stage.bazaarghar.com/streaming/v1/")! 
//            return URL(string: "http://192.168.1.23:3002/streaming/v1/")!
            
            
        case .prod:
            return URL(string: "https://api.mysouq.com/streaming/v1/")!
        case.local:

          
          return URL(string: "http://192.168.1.23:3002/streaming/v1/")!

        case.stagemysouq:
          return URL(string: "https://api-stage.mysouq.com/streaming/v1/")!
          
         

          
          
        }
      }
    static var baseURLChat: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://chat-apid.bazaarghar.com/chat/v1/message")!
        case .staging:
//        return URL(string: "http://192.168.1.23:3003/chat/v1/message")!
          return URL(string: "https://chat-api-stage.bazaarghar.com/chat/v1/message")!
      case .prod:
        //return URL(string: "http://192.168.1.23:3003/chat/v1/message")!
          return URL(string: "https://chat-api.mysouq.com/chat/v1/message")!
      case.local:

        
        return URL(string: "http://192.168.1.23:3003/chat/v1/message")!

      case.stagemysouq:
        return URL(string: "https://chat-api-stage.mysouq.com/v1/message/")!
        
       

        
        
      }
    }
    static var chinesBellUrl: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://chat-apid.bazaarghar.com/chat/v1/notification")!
        case .staging:
//        return URL(string: "http://192.168.1.23:3003/chat/v1/notification")!
          return URL(string: "https://chat-api-stage.bazaarghar.com/chat/v1/notification")!
      case .prod:
        //return URL(string: "http://192.168.1.23:3003/chat/v1/message")!
          return URL(string: "https://chat-api.mysouq.com/chat/v1/notification")!
      case.local:

        
        return URL(string: "http://192.168.1.23:3003/chat/v1/notification")!
      case.stagemysouq:
        return URL(string: "https://chat-api-stage.mysouq.com/v1/notification/")!

        
     

        
        
      }
    }
    static var baseURLChatNotification: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://chat-apid.bazaarghar.com/chat/v1/")!
        case .staging:
//        return URL(string: "http://192.168.1.:3003/chat/v1/message")!
          
          return URL(string: "https://chat-api-stage.bazaarghar.com/chat/v1/")!
      case .prod:

        //return URL(string: "http://192.168.1.23:3003/chat/v1/message")!
          return URL(string: "https://chat-api.mysouq.com/chat/v1/")!
      case.local:

        
        return URL(string: "http://192.168.1.23:3003/chat/v1/")!
      case.stagemysouq:
        return URL(string: "https://chat-api-stage.mysouq.com/chat/v1/")!

          
      }
    }
  
    static var baseURLString = AppConstants.API.baseURL.absoluteString

  }
  struct UserDefaultKeys{
    static let user = "user"
  }
  struct Keys{
    static let googleApiKey = "AIzaSyDmGVRqxuXsUGlDBosd3I5ptRVySLSi6UQ"
  }
}
