import ExpoModulesCore
import BrightcovePlayerSDK

extension UIColor {
	public convenience init?(hex: String) {
		let r, g, b, a: CGFloat
		print(hex)
		
		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex[start...])
			print(hexColor)
			
			if hexColor.count >= 6 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = hexColor.count == 8 ? CGFloat(hexNumber & 0x000000ff) / 255 : 1
					
					self.init(red: r, green: g, blue: b, alpha: a)
					return
				}
			}
		}
		
		return nil
	}
}

class PlayerView: ExpoView, BCOVPlaybackControllerDelegate {
	var url: String? = nil
	var isVR: Bool? = nil
	var seekEnabled: Bool? = nil
	var trackColor: String? = nil;
	
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
		let loaded = isVR != nil && url != nil && seekEnabled != nil && trackColor != nil
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
		
		let vrProperties = [kBCOVVideoPropertyKeyProjection: "equirectangular"]
		let properties = isVR! ? vrProperties : nil

		controller.viewProjection = BCOVVideo360ViewProjection()
		let source = BCOVSource(url: URL(string: url!)!, deliveryMethod: kBCOVSourceDeliveryHLS, properties: properties)
		let video = BCOVVideo(source: source, cuePoints: nil, properties: properties)
		let videos: NSArray = [video] as NSArray
		controller.setVideos(videos)
		
		self.myView = BCOVPUIPlayerView(playbackController: nil, options: options, controlsView: controlView)
		myView?.playbackController = controller
		addSubview(myView!)
	}
	
	func playbackController(_ controller: BCOVPlaybackController!, didCompletePlaylist playlist: NSFastEnumeration!) {
		self.onDidCompletePlaylist([:]);
	}
	
	func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
		let n = NSNumber(value: progress)
		self.onDidProgressTo(["progress": n]);
	}
}
