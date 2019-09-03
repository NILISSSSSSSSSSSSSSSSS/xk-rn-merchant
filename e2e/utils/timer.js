exports.delay = function (second = 1, done = () => {}) {
  return new Promise((resolve, reject) => {
    try {
      setTimeout(() => {
        resolve(true);
        done();
      }, second * 1000);
    } catch (error) {
      reject(error);
      done(-1);
    }
  });
};
