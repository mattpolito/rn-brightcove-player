import { useCallback, useEffect, useRef } from "react";
import { StyleSheet, View } from "react-native";
import {
  OnDidProgressToType,
  BrightcovePlayer,
  seekTo,
  play,
  pause,
} from "rn-brightcove-player";

const isVR = false;
const appColor = "#69499e";
const url = "https://www.w3schools.com/HTML/mov_bbb.mp4";

export default function App() {
  const playerRef = useRef<BrightcovePlayer>(null);

  const onDidCompletePlaylist = useCallback(() => {
    console.warn("Did complete playlist");
  }, []);

  const onDidProgressTo = useCallback(
    ({ nativeEvent: { progress } }: OnDidProgressToType) => {
      // console.warn(`Did progress to ${progress}`);
    },
    []
  );

  useEffect(() => {
    setTimeout(() => {
      seekTo(18);
    }, 5000);

    setTimeout(() => {
      pause();
    }, 7000);

    setTimeout(() => {
      play();
    }, 9000);
  }, []);

  return (
    <View style={styles.container}>
      <BrightcovePlayer
        ref={playerRef}
        style={styles.player}
        isVR={isVR}
        seekEnabled={false}
        trackColor={appColor}
        url={url}
        onDidCompletePlaylist={onDidCompletePlaylist}
        onDidProgressTo={onDidProgressTo}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  player: {
    ...StyleSheet.absoluteFillObject,
  },
  container: {
    flex: 1,
    backgroundColor: "#aaa",
    alignItems: "center",
    justifyContent: "center",
  },
});
