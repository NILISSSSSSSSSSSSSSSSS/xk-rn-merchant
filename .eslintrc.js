module.exports = {
  root: true,
  extends: '@react-native-community',
  "globals": {
      "Atomics": "readonly",
      "SharedArrayBuffer": "readonly",
      "Toast": true,
      "Loading": true,
      "CustomAlert": true,
      "app": true,
      "RightTopModal": true,
  },
  rules: {
    "prettier/prettier": 0,
    "react-native/no-inline-styles": 0,
    "no-return-assign": 0,
    "curly": 0,
    "handle-callback-err": 0,
  }
};
