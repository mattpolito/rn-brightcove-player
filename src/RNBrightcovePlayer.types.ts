import { ViewProps } from "react-native";

export type OnDidProgressToType = {
  nativeEvent: { progress: number };
};

export type RNBrightcovePlayerViewProps = {
  url: string;
  isVR?: boolean;
  trackColor?: string;
  projection?: string;
  seekEnabled?: boolean;
  controls?: boolean;
  autoplay?: boolean;
  bitRate?: { title: string; options: { [key: string]: number }[] };
  onDidCompletePlaylist?(): void;
  onControlsFadeIn?(): void;
  onControlsFadeOut?(): void;
  onDidProgressTo?(e: OnDidProgressToType): void;
} & ViewProps;
