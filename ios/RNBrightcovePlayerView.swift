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

class PlayerView: ExpoView, BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate {
	var url: String? = nil
	var isVR: Bool? = nil
  var autoplay: Bool? = nil
  var fullscreen: Bool? = nil
	var seekEnabled: Bool? = nil
	var trackColor: String? = nil
	var projection: String? = nil
  var bitRateTitle: String? = nil
  var options: [[String: Int]]? = nil
  var controls: Bool? = nil

	var myView: BCOVPUIPlayerView? = nil
	var myController: BCOVPlaybackController? = nil
	let onDidCompletePlaylist = EventDispatcher()
	let onDidProgressTo = EventDispatcher()
  let onWillTransitionTo = EventDispatcher()
  let onControlsFadeIn = EventDispatcher()
  let onControlsFadeOut = EventDispatcher()

	override func layoutSubviews() {
		myView?.frame = bounds
	}
	
	required init(appContext: AppContext? = nil) {
		super.init(appContext: appContext)
		clipsToBounds = true
	}

	func load() {
		let loaded = isVR != nil &&
    url != nil &&
    seekEnabled != nil &&
    trackColor != nil &&
    projection != nil &&
    autoplay != nil &&
    options != nil &&
    bitRateTitle != nil &&
    controls != nil

		if (!loaded) {
			return
		}
		
		let playerOptions = BCOVPUIPlayerViewOptions()
		playerOptions.presentingViewController = self.reactViewController()
    if (bitRateTitle != "" && options!.count > 0) {
      var bitRateOptions: [[String: NSNumber]] = []
      options.map {
        bitRateOptions = $0.map { $0.mapValues { NSNumber(value: $0) } }
      }

      playerOptions.preferredBitrateConfig = BCOVPreferredBitrateConfig(
        menuTitle: bitRateTitle,
        andBitrateOptions: bitRateOptions
      )
    }


    // LAYOUT
    let playbackLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonPlayback, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let goBackView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonJumpBack, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let cardboardView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonVideo360, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let closedCaptionView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonClosedCaption, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let currentTimeLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .labelCurrentTime, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let durationLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .labelDuration, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let progressLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .sliderProgress, width: kBCOVPUILayoutUseDefaultValue, elasticity: 1.0)
    let spacerLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewEmpty, width: kBCOVPUILayoutUseDefaultValue, elasticity: 1.0)
    let screenModeLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonScreenMode, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let bitLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonPreferredBitrate, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
    let buttonLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewEmpty, width: 40, elasticity: 0)
    if let buttonLayoutView = buttonLayoutView {
      let button = UIButton(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
      let image = UIImage(systemName: "dot.viewfinder")!.withTintColor(.white, renderingMode: .alwaysOriginal)
      button.setBackgroundImage(image, for: .normal)
      buttonLayoutView.addSubview(button)
      button.addTarget(self, action: #selector(self.centerView), for: .touchUpInside)
    }

    let standardLayoutLine1 = [
      playbackLayoutView,
      goBackView,
      currentTimeLayoutView,
      progressLayoutView,
      durationLayoutView,
      closedCaptionView,
    ]

    // Remove center button due to Brightcove bug
    // var standardLayoutLine2 = isVR! ? [buttonLayoutView] : []
//    standardLayoutLine2.append(contentsOf: [
    let standardLayoutLine2 = [
      closedCaptionView,
      spacerLayoutView,
      cardboardView,
      screenModeLayoutView,
      bitLayoutView,
    ]

    let compactLayoutLine1 = [
      playbackLayoutView,
      currentTimeLayoutView,
      progressLayoutView,
      durationLayoutView,
    ]
    var compactLayoutLine2 = [
      goBackView
    ]
    // Remove center button due to Brightcove bug
    // if isVR! {
    //   compactLayoutLine2.append(contentsOf: [
    //     buttonLayoutView
    //   ])
    // }
    compactLayoutLine2.append(contentsOf: [
      closedCaptionView,
      spacerLayoutView,
      cardboardView,
      screenModeLayoutView,
      bitLayoutView,
    ])

    let standardLayoutLines = [standardLayoutLine1, standardLayoutLine2]
    let compactLayoutLines = [compactLayoutLine1, compactLayoutLine2]


		let manager = BCOVPlayerSDKManager.shared()!
		let controller = manager.createPlaybackController()!
		controller.isAutoPlay = autoplay!
		controller.isAutoAdvance = true
		controller.thumbnailSeekingEnabled = seekEnabled!
		controller.delegate = self
		self.myController = controller
		
    var properties: [String: Any] = [:]
    if (isVR!) {
      properties[kBCOVVideoPropertyKeyProjection] = projection!
    }
		controller.viewProjection = BCOVVideo360ViewProjection()
		let source = BCOVSource(url: URL(string: url!)!, deliveryMethod: kBCOVSourceDeliveryHLS, properties: properties)
		let video = BCOVVideo(source: source, cuePoints: nil, properties: properties)
		let videos: NSArray = [video] as NSArray
		controller.setVideos(videos)

    let layout = BCOVPUIControlLayout(standardControls: standardLayoutLines, compactControls: compactLayoutLines)
    let controlView = BCOVPUIBasicControlView.withVODLayout()
    let color = UIColor(hex: trackColor!)

    controlView?.layout = layout
    controlView?.progressSlider.minimumTrackTintColor = color
    controlView?.progressSlider.isEnabled = seekEnabled!

		self.myView = BCOVPUIPlayerView(playbackController: nil, options: playerOptions, controlsView: controlView)
		myView?.playbackController = controller
    myView?.delegate = self
    addSubview(myView!)

    self.myView?.video360NavigationMethod = .fingerTracking
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(seekTo), name: .seekTo, object: nil)
		nc.addObserver(self, selector: #selector(play), name: .play, object: nil)
		nc.addObserver(self, selector: #selector(pause), name: .pause, object: nil)
    nc.addObserver(self, selector: #selector(presentFullscreenPlayer), name: .presentFullscreenPlayer, object: nil)
    nc.addObserver(self, selector: #selector(centerView), name: .center, object: nil)
	}
	
	@objc func play(notification: Notification) {
    self.myController?.play()
	}

  @objc func presentFullscreenPlayer(notification: Notification) {
    self.myView?.performScreenTransition(with: BCOVPUIScreenMode.full)
  }

	@objc func pause(notification: Notification) {
		self.myController?.pause()
	}

  @objc func centerView(_ sender: UIButton) {
    self.myView?.video360NavigationMethod = .fingerTracking
    self.myView!.playbackController.viewProjection = BCOVVideo360ViewProjection()
    self.myView!.playbackController.viewProjection.tilt = 0
    self.myView!.playbackController.viewProjection.pan = 0
    self.myView!.playbackController.viewProjection.roll = 0
    self.myView!.playbackController.viewProjection.zoom = 0
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

  func playerView(_ playerView: BCOVPUIPlayerView!, willTransitionTo screenMode: BCOVPUIScreenMode) {
    self.onWillTransitionTo(["screenMode": screenMode]);
  }

  func playerView(_ playerView: BCOVPUIPlayerView!, controlsFadingViewDidFadeIn controlsFadingView: UIView!) {
    self.onControlsFadeIn([:]);
  }

  func playerView(_ playerView: BCOVPUIPlayerView!, controlsFadingViewDidFadeOut controlsFadingView: UIView!) {
    self.onControlsFadeOut([:]);
  }

	deinit {
		let nc = NotificationCenter.default
		nc.removeObserver(self, name: .seekTo , object: nil)
		nc.removeObserver(self, name: .play , object: nil)
		nc.removeObserver(self, name: .pause , object: nil)
    nc.removeObserver(self, name: .presentFullscreenPlayer, object: nil)
    nc.removeObserver(self, name: .center, object: nil)
	}
}
