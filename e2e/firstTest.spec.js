const {
  device, expect, element, by, waitFor,
} = require('detox');
const { delay } = require('./utils/timer');

describe('AppIntroScreen', () => {
  it('should have appIntroScreen screen', async () => {
    await device.launchApp({
      permissions: {
        calendar: 'YES', camera: 'YES', location: 'always', photos: 'YES', notifications: 'YES',
      },
      newInstance: true,
    });
    await device.reloadReactNative();
    console.log('should have appIntroScreen screen');
    const ele = await element(by.id('appIntroScreen'));
    if (ele) {
      console.log("tap introGoTo")
      await element(by.id('introGoTo')).tap();
      console.log("tapped introGoTo")
      await delay(2);
      console.log("goto loginScreen")
      await expect(element(by.id('loginScreen'))).toExist();
      console.log("goneto loginScreen")
    }
  });
});
