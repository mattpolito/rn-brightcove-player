package expo.modules.rnbrightcoveplayer

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class RNBrightcovePlayerModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("RNBrightcovePlayer")

    Events("onChange")

    Function("hellow") { "Bye" }

    AsyncFunction("setValueAsync") { value: String ->
      sendEvent("onChange", mapOf("value" to value))
    }

    View(RNBrightcovePlayerView::class) {
      Prop("trackColor") { view: RNBrightcovePlayerView, trackColor: String? ->
        view.trackColor = trackColor
        view.load()
      }

      Prop("isVR") { view: RNBrightcovePlayerView, isVR: Boolean? ->
        view.isVR = isVR
        view.load()
      }

      Prop("url") { view: RNBrightcovePlayerView, url: String? ->
        view.url = url
        view.load()
      }
    }
  }
}
