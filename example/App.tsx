import { useCallback, useRef } from "react";
import { StyleSheet, View } from "react-native";
import { OnDidProgressToType, BrightcovePlayer } from "rn-brightcove-player";

const isVR = false;
const appColor = "#6699FF";
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
