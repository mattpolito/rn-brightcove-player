import { ViewProps } from "react-native";

export type OnDidProgressToType = {
  nativeEvent: { progress: number };
};

export type RNBrightcovePlayerViewProps = {
  url: string;
  isVR?: boolean;
  trackColor?: string;
  seekEnabled?: boolean;
  onDidCompletePlaylist?(): void;
  onDidProgressTo?(e: OnDidProgressToType): void;
} & ViewProps;
