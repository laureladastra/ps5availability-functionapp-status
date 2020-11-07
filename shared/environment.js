const puppeteer = require('puppeteer');
let browser;

module.exports = async function () {
  const options = {
    headless: true,
    timeout: 3000,
    waitUntil: 'networkidle2',
    args: ['--start-maximized'],
    defaultViewport: {
      width: 1280,
      height: 1280
    }
  };
  if (!browser) {
    browser = await puppeteer.launch(options);
  }
  return browser;
};
