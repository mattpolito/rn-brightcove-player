import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";
import { RNBrightcovePlayerViewProps } from "./RNBrightcovePlayer.types";

const NativeView: React.ComponentType<RNBrightcovePlayerViewProps> =
  requireNativeViewManager("RNBrightcovePlayer");

export default class RNBrightcovePlayerView extends React.Component<RNBrightcovePlayerViewProps> {
  render() {
    const {
      isVR = false,
      trackColor = "#cccccc",
      seekEnabled = false,
      autoplay = false,
      controls = true,
      projection = "equirectangular",
      bitRate = { title: "Quality", options: [] },
      ...props
    } = this.props;

    return (
      <NativeView
        isVR={isVR}
        trackColor={trackColor}
        autoplay={autoplay}
        seekEnabled={seekEnabled}
        projection={projection}
        controls={controls}
        bitRate={bitRate}
        {...props}
      />
    );
  }
}
