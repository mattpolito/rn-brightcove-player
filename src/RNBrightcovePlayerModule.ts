import { requireNativeModule } from "expo-modules-core";

// It loads the native module object from the JSI or falls back to
// the bridge module (from NativeModulesProxy) if the remote debugger is on.
const RNBrightcovePlayer = requireNativeModule("RNBrightcovePlayer");
export async function seekTo(seconds: number) {
  return await RNBrightcovePlayer.seekTo(seconds);
}

export async function play() {
  return await RNBrightcovePlayer.play();
}

export async function pause() {
  return await RNBrightcovePlayer.pause();
}

export async function presentFullscreenPlayer() {
  return await RNBrightcovePlayer.presentFullscreenPlayer();
}
