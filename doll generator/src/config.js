const basePath = process.cwd();
const { MODE } = require(`${basePath}/constants/blend_mode.js`);
const { NETWORK } = require(`${basePath}/constants/network.js`);

const network = NETWORK.eth;

// General metadata for Ethereum
const namePrefix = "dollhouse";
const description = "be a doll. mint a doll.";
const baseUri = "ipfs://QmVDQANnLV9WC997McCQGrNQyjU7iGynwbG1U3rGjpz1ks";
const layerConfigurations = [
  {
    growEditionSizeTo: 100,
    layersOrder: [
      { name: "Background"},
      { name: "Bust" },
      { name: "Face" },
      { name: "Blush" },
      { name: "Eye Shadow" },
      { name: "Eyes" },
      { name: "Hair" },
      { name: "Lipstick"},
      { name: "Lashes"},  
    ],
  },
];

const shuffleLayerConfigurations = true;

const debugLogs = false;

const format = {
  width: 2400,
  height: 2400,
  smoothing: false,
};

const gif = {
  export: false,
  repeat: 0,
  quality: 100,
  delay: 500,
};

const text = {
  only: false,
  color: "#ffffff",
  size: 20,
  xGap: 40,
  yGap: 40,
  align: "left",
  baseline: "top",
  weight: "regular",
  family: "Courier",
  spacer: " => ",
};

const pixelFormat = {
  ratio: 2 / 128,
};

const background = {
  generate: false,
  brightness: "70%",
  static: false,
};

const extraMetadata = {
  artist: "bossbratbimbo",
  url: "https://dollface.shop",
};

const rarityDelimiter = "#";

const uniqueDnaTorrance = 10000;

const preview = {
  thumbPerRow: 20,
  thumbWidth: 100,
  imageRatio: format.height / format.width,
  imageName: "dollhouse_preview.png",
};

const preview_gif = {
  numberOfImages: 11,
  order: "ASC", // ASC, DESC, MIXED
  repeat: 0,
  quality: 100,
  delay: 500,
  imageName: "dollhouse_preview.gif",
};

module.exports = {
  format,
  baseUri,
  description,
  background,
  uniqueDnaTorrance,
  layerConfigurations,
  rarityDelimiter,
  preview,
  shuffleLayerConfigurations,
  debugLogs,
  extraMetadata,
  pixelFormat,
  text,
  namePrefix,
  network,
  gif,
  preview_gif,
};
