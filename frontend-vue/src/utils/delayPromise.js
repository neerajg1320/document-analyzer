export default {
  async delayPromise (delayInms, data) {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve(data);
      }, delayInms);
    });
  }
}
