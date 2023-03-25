package expo.modules.rnbrightcoveplayer

import android.content.Context
import com.brightcove.player.mediacontroller.BrightcoveMediaController
import com.brightcove.player.model.Video
import com.brightcove.player.view.BrightcoveExoPlayerVideoView
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.views.ExpoView

class RNBrightcovePlayerView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  var trackColor: String? = null
  var url: String? = null
  var isVR: Boolean? = null
  var mediaController: BrightcoveMediaController? = null

  internal val player: BrightcoveExoPlayerVideoView =
      BrightcoveExoPlayerVideoView(context).also {
        it.layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        it.finishInitialization()

        this.mediaController = BrightcoveMediaController(it)
        it.setMediaController(this.mediaController)
        requestLayout()

        addView(it)
      }

  fun load() {
    val url = this.url
    val isVR = this.isVR
    val trackColor = this.trackColor

    if (url != null && isVR != null && trackColor != null) {
      val projectionFormat =
          when (isVR) {
            true -> Video.ProjectionFormat.EQUIRECTANGULAR
            false -> Video.ProjectionFormat.NORMAL
          }

      var video = Video.createVideo(url)
      this.player.add(video)
      this.player.start()
      //this.player.replace(0, Video.createVideo(url, projectionFormat))
    }
  }
}
