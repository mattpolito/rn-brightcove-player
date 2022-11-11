# rn-brightcove-player

API Example:

```ts
type OnDidProgressToType = {
  nativeEvent: { progress: number };
};

type RNBrightcovePlayerViewProps = {
  url: string;
  isVR?: boolean;
  trackColor?: string;
  projection?: string;
  seekEnabled?: boolean;
  onDidCompletePlaylist?(): void;
  onDidProgressTo?(e: OnDidProgressToType): void;
} & ViewProps;
```

```ts
import { useCallback, useRef } from "react";
import { StyleSheet, View } from "react-native";
import { OnDidProgressToType, BrightcovePlayer } from "rn-brightcove-player";

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

```

# API documentation

- [Documentation for the main branch](https://github.com/expo/expo/blob/main/docs/pages/versions/unversioned/sdk/rn-brightcove-player.md)
- [Documentation for the latest stable release](https://docs.expo.dev/versions/latest/sdk/rn-brightcove-player/)

# Installation in managed Expo projects

For [managed](https://docs.expo.dev/versions/latest/introduction/managed-vs-bare/) Expo projects, please follow the installation instructions in the [API documentation for the latest stable release](#api-documentation). If you follow the link and there is no documentation available then this library is not yet usable within managed projects &mdash; it is likely to be included in an upcoming Expo SDK release.

# Installation in bare React Native projects

For bare React Native projects, you must ensure that you have [installed and configured the `expo` package](https://docs.expo.dev/bare/installing-expo-modules/) before continuing.

### Add the package to your npm dependencies

```
npm install rn-brightcove-player
```

### Configure for iOS

Run `npx pod-install` after installing the npm package.


### Configure for Android



# Contributing

Contributions are very welcome! Please refer to guidelines described in the [contributing guide]( https://github.com/expo/expo#contributing).
