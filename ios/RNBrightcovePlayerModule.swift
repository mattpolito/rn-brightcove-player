import ExpoModulesCore

public class RNBrightcovePlayerModule: Module {
	// Each module class must implement the definition function. The definition consists of components
	// that describes the module's functionality and behavior.
	// See https://docs.expo.dev/modules/module-api for more details about available components.
	public func definition() -> ModuleDefinition {
		// Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
		// Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
		// The module will be accessible from `requireNativeModule('RNBrightcovePlayer')` in JavaScript.
		Name("RNBrightcovePlayer")
		
		View(PlayerView.self) {
			
			// Enables the module to be used as a native view. Definition components that are accepted as part of the
			// view definition: Prop, Events.
			Events("onDidCompletePlaylist")
			Events("onDidProgressTo")
			
			Prop("isVR") { (view: PlayerView, isVR: Bool) in
				view.isVR = isVR
				view.load()
			}
			Prop("seekEnabled") { (view: PlayerView, seekEnabled: Bool) in
				view.seekEnabled = seekEnabled
				view.load()
			}
			Prop("trackColor") { (view: PlayerView, trackColor: String) in
				view.trackColor = trackColor
				view.load()
			}
			Prop("projection") { (view: PlayerView, projection: String) in
				view.projection = projection
				view.load()
			}
			Prop("url") { (view: PlayerView, url: String) in
				view.url = url
				view.load()
			}
		}
	}
}
