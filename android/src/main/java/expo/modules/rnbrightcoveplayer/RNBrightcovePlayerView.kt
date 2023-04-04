package expo.modules.rnbrightcoveplayer

import android.content.Context
import androidx.core.view.ViewCompat
import com.brightcove.player.event.Event
import com.brightcove.player.event.EventListener
import com.brightcove.player.event.EventType
import com.brightcove.player.mediacontroller.BrightcoveMediaController
import com.brightcove.player.model.Video
import com.brightcove.player.view.BrightcoveExoPlayerVideoView
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView

class CustomListener(internal val callback: (e: Event) -> Unit) : EventListener {
  override fun processEvent(e: Event) {
    callback(e)
  }
}

class RNBrightcovePlayerView(context: Context, appContext: AppContext) :
    ExpoView(context, appContext) {
  private val onDidProgressTo by EventDispatcher()
  private val onDidCompletePlaylist by EventDispatcher()

  var trackColor: String? = null
  var url: String? = null
  var isVR: Boolean? = null
  var mediaController: BrightcoveMediaController? = null

  internal val player =
      BrightcoveExoPlayerVideoView(context).also {
        it.layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        it.finishInitialization()
        requestLayout()

        this.mediaController = BrightcoveMediaController(it)
        it.setMediaController(this.mediaController)

        ViewCompat.setTranslationZ(this, 9999.toFloat())

        val eventEmitter = it.getEventEmitter()
        eventEmitter.on(EventType.READY_TO_PLAY, CustomListener(this::load))
        eventEmitter.on(EventType.PROGRESS, CustomListener(this::onNotifyProgress))
        eventEmitter.on(EventType.COMPLETED, CustomListener(this::onCompleted))

        addView(it)
      }

  fun onCompleted(e: Event) {
    onDidCompletePlaylist(mapOf("complete" to true))
  }

  fun onNotifyProgress(e: Event) {
    onDidProgressTo(mapOf("progress" to e.getLongProperty(("playheadPositionLong"))))
  }

  fun play() {
    this.player.start()
  }

  fun pause() {
    this.player.pause()
  }

  fun load(e: Event) {
    val url = this.url
    val isVR = this.isVR
    val trackColor = this.trackColor

    if (url != null && isVR != null && trackColor != null) {
      val projectionFormat =
          when (isVR) {
            true -> Video.ProjectionFormat.EQUIRECTANGULAR
            false -> Video.ProjectionFormat.NORMAL
          }

      var video = Video.createVideo(url, projectionFormat)
      player.add(video)
      player.start()
    }
  }
}
