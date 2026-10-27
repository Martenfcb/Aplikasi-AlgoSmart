module.exports = {
  env: {
    es6: true,
    node: true,
  },

  parserOptions: {
    ecmaVersion: 2022,
  },

  extends: [
    "eslint:recommended",
    "google",
  ],

  rules: {
    "no-restricted-globals": [
      "error",
      "name",
      "length",
    ],

    "prefer-arrow-callback": "error",

    "quotes": [
      "error",
      "double",
      {
        "allowTemplateLiterals": true,
      },
    ],

    // JSDoc tidak wajib untuk Cloud Functions
    "require-jsdoc": "off",

    // Tidak wajib menulis JSDoc valid
    "valid-jsdoc": "off",

    // Tidak memaksa setiap async function memiliki await
    "require-await": "off",
  },

  overrides: [
    {
      files: ["**/*.spec.*"],

      env: {
        mocha: true,
      },

      rules: {},
    },
  ],

  globals: {},
};
