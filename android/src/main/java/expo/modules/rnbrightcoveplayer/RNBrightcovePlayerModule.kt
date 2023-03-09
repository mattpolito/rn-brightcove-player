package expo.modules.rnbrightcoveplayer

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class RNBrightcovePlayerModule : Module() {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  override fun definition() = ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a
    // string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for
    // clarity.
    // The module will be accessible from `requireNativeModule('RNBrightcovePlayer')` in JavaScript.
    Name("RNBrightcovePlayer")

    // Defines event names that the module can send to JavaScript.
    Events("onChange")

    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("hellow") { "Bye" }

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    AsyncFunction("setValueAsync") { value: String ->
      // Send an event to JavaScript.
      sendEvent("onChange", mapOf("value" to value))
    }

    // Enables the module to be used as a native view. Definition components that are accepted as
    // part of
    // the view definition: Prop, Events.
    View(RNBrightcovePlayerView::class) {
      Prop("trackColor") { view: RNBrightcovePlayerView, trackColor: String? ->
        view.trackColor = trackColor
        view.load()
      }

      Prop("isVR") { view: RNBrightcovePlayerView, isVR: Boolean? ->
        view.isVR = isVR
        view.load()
      }

      // Defines a setter for the `name` prop.
      Prop("url") { view: RNBrightcovePlayerView, url: String? ->
        view.url = url
        view.load()
      }
    }
  }
}
