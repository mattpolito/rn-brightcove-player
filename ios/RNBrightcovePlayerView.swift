import ExpoModulesCore
import BrightcovePlayerSDK

func hexStringToUIColor (_ hex:String) -> UIColor {
	var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
	
	if (cString.hasPrefix("#")) {
		cString.remove(at: cString.startIndex)
	}
	
	if ((cString.count) != 6) {
		return UIColor.gray
	}
	
	var rgbValue:UInt64 = 0
	Scanner(string: cString).scanHexInt64(&rgbValue)
	
	return UIColor(
		red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
		green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
		blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
		alpha: CGFloat(1.0)
	)
}

extension UIColor {
	public convenience init?(hex: String) {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		if ((cString.count) != 6) {
			return nil
		}
		
		var rgbValue:UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
		return;
	}
}

class PlayerView: ExpoView, BCOVPlaybackControllerDelegate {
	var url: String? = nil
	var isVR: Bool? = nil
	var seekEnabled: Bool? = nil
	var trackColor: String? = nil;
	var projection: String? = nil
	
	var myView: BCOVPUIPlayerView? = nil
	var myController: BCOVPlaybackController? = nil
	let onDidCompletePlaylist = EventDispatcher()
	let onDidProgressTo = EventDispatcher()
	
	override func layoutSubviews() {
		myView?.frame = bounds
	}
	
	required init(appContext: AppContext? = nil) {
		super.init(appContext: appContext)
		clipsToBounds = true
	}
	
	func load() {
		let loaded = isVR != nil && url != nil && seekEnabled != nil && trackColor != nil && projection != nil
		if (!loaded) {
			return
		}
		
		let options = BCOVPUIPlayerViewOptions()
		options.presentingViewController = self.reactViewController()
		
		let controlView = BCOVPUIBasicControlView.withVODLayout()
		let color = UIColor(hex: trackColor!)
		controlView?.progressSlider.minimumTrackTintColor = color
		controlView?.progressSlider.isEnabled = seekEnabled!
		
		
		let manager = BCOVPlayerSDKManager.shared()!
		let controller = manager.createPlaybackController()!
		controller.isAutoPlay = true
		controller.isAutoAdvance = true
		controller.thumbnailSeekingEnabled = seekEnabled!
		controller.delegate = self
		self.myController = controller
		
		let vrProperties = [kBCOVVideoPropertyKeyProjection: projection!]
		let properties = isVR! ? vrProperties : nil
		
		controller.viewProjection = BCOVVideo360ViewProjection()
		let source = BCOVSource(url: URL(string: url!)!, deliveryMethod: kBCOVSourceDeliveryHLS, properties: properties)
		let video = BCOVVideo(source: source, cuePoints: nil, properties: properties)
		let videos: NSArray = [video] as NSArray
		controller.setVideos(videos)
		
		self.myView = BCOVPUIPlayerView(playbackController: nil, options: options, controlsView: controlView)
		myView?.playbackController = controller
		addSubview(myView!)
		
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(seekTo), name: .seekTo, object: nil)
		nc.addObserver(self, selector: #selector(play), name: .play, object: nil)
		nc.addObserver(self, selector: #selector(pause), name: .pause, object: nil)
	}
	
	@objc func play(notification: Notification) {
		self.myController?.play()
	}
	
	@objc func pause(notification: Notification) {
		self.myController?.pause()
	}
	
	@objc func seekTo(notification: Notification) {
		if let data = notification.userInfo as? [String: Double] {
			for (_, seconds) in data {
				let seekTime = CMTimeMakeWithSeconds(seconds, preferredTimescale: Int32(NSEC_PER_SEC))
				self.myController?.seek(to: seekTime, completionHandler: nil)
			}
		}
	}
	
	func playbackController(_ controller: BCOVPlaybackController!, didCompletePlaylist playlist: NSFastEnumeration!) {
		self.onDidCompletePlaylist([:]);
	}
	
	func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
		let n = NSNumber(value: progress)
		self.onDidProgressTo(["progress": n]);
	}
	
	deinit {
		let nc = NotificationCenter.default
		nc.removeObserver(self, name: .seekTo , object: nil)
		nc.removeObserver(self, name: .play , object: nil)
		nc.removeObserver(self, name: .pause , object: nil)
	}
}
