const { withDangerousMod, withPlugins } = require("@expo/config-plugins");
const {
  mergeContents,
} = require("@expo/config-plugins/build/utils/generateCode");
const fs = require("fs");
const path = require("path");

async function readFileAsync(path) {
  return fs.promises.readFile(path, "utf8");
}

async function saveFileAsync(path, content) {
  return fs.promises.writeFile(path, content, "utf8");
}

const withAddMavenSource = (c) => {
  return withDangerousMod(c, [
    "android",
    async (config) => {
      const file = path.join(
        config.modRequest.platformProjectRoot,
        "build.gradle"
      );
      const contents = await readFileAsync(file);
      await saveFileAsync(file, addMavenSource(contents));
      return config;
    },
  ]);
};

function addMavenSource(src) {
  return mergeContents({
    tag: `rn-add-github-source`,
    src,
    newSrc: "maven { url 'https://repo.brightcove.com/releases' }",
    anchor: /jitpack.io/,
    offset: 1,
    comment: "//",
  }).contents;
}

module.exports = (config) => withPlugins(config, [withAddMavenSource]);