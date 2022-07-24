## Overview

We use js_api in the wallet

We use the file js_api/dist/main.js

We use webpack to generate this file

Polkawallet also has js_as_extension but not sure what the difference is.

## Generating the main.js file

```
cd js_api
yarn
webpack
```

## Process

If you do this, first run the above commands without any changes to any .ts or .js files, to see if main.js that is generated is the same as the one that's checked in. 

If not, then don't modify or run webpack

If yes, good to go

