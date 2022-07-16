
console.log('JS core loaded. Call init({endpoint: "..."})');
console.log('core window 1');

function testinit(url) {
  console.log("testinig was being called "+url);
}

service = {
  keyringAddFromUri,
  getBalance,
  init,
  testinit,
};

console.log('core window ' + service);
