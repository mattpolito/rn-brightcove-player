package expo.modules.rnbrightcoveplayer

import com.brightcove.player.event.EventType
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class RNBrightcovePlayerModule : Module() {
  internal var nativeView: RNBrightcovePlayerView? = null

  override fun definition() = ModuleDefinition {
    Name("RNBrightcovePlayer")

    AsyncFunction("play") {
      val pl = nativeView
      if (pl != null) {
        pl.player.getEventEmitter().emit(EventType.PLAY)
      }
    }

    AsyncFunction("pause") {
      val pl = nativeView
      if (pl != null) {
        pl.player.getEventEmitter().emit(EventType.PAUSE)
      }
    }

    AsyncFunction("seekTo") { value: Double ->
      val pl = nativeView
      if (pl != null) {
        pl.player.getEventEmitter().emit(EventType.SEEK_TO, mapOf("seekTo" to value))
      }
    }

    View(RNBrightcovePlayerView::class) {
      Events("onDidCompletePlaylist", "onDidProgressTo")
      Prop("trackColor") { view: RNBrightcovePlayerView, trackColor: String? ->
        nativeView = view
        view.trackColor = trackColor
      }
      Prop("isVR") { view: RNBrightcovePlayerView, isVR: Boolean? ->
        nativeView = view
        view.isVR = isVR
      }
      Prop("url") { view: RNBrightcovePlayerView, url: String? ->
        nativeView = view
        view.url = url
      }
    }
  }
}
