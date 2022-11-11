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
      projection = "equirectangular",
      ...props
    } = this.props;

    return (
      <NativeView
        isVR={isVR}
        trackColor={trackColor}
        seekEnabled={seekEnabled}
        projection={projection}
        {...props}
      />
    );
  }
}
