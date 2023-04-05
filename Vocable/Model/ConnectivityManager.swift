import SystemConfiguration
import Alamofire

class ConnectivityManager{

    class var checkNetworkStatus:Bool {
        return NetworkReachabilityManager(host: "www.google.com")!.isReachable
    }
    
    private func isNetworkReachable (with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains (.reachable)
        let needsConnection = flags.contains (.connectionRequired)
        let canConnectionAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectionAutomatically && !flags.contains  (.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
}
