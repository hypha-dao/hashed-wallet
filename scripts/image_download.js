const download = require('image-downloader');
const fs = require('fs');

const data = require("../assets/polkadot/logo_info.json");

const currentDirectory = process.cwd();
const imageDirectory = "logos"
console.log("Current directory: " + currentDirectory);

const rawUrlPrefix =
    "https://raw.githubusercontent.com/polkadot-js/apps/master/packages/apps-config/src/ui/logos";

const paths = [
    "chains",
    "nodes"
]

async function downloadImage(url, filepath) {
    return download.image({
        url,
        dest: filepath
    });
}
const myString = "Hello, World! This is a test.";
const myNewString = myString.replace(/ /g, "_");

console.log(myNewString); // Output: "Hello,_World!_This_is_a_test."

async function main() {
    //console.log(data)
    for (const [key, value] of Object.entries(data)) {
        console.log(`${key}: ${value}`);
        var downloaded = false
        const keyWithoutSpaces = key.replace(/ /g, "_");

        var extension = ""
        if (value.endsWith(".svg")) {
            extension = ".svg"
        } else if (value.endsWith(".png")) {
            extension = ".png"
        } else if (value.endsWith(".jpg")) {
            extension = ".jpg"
        } else if (value.endsWith(".gif")) {
            extension = ".gif"
        } else {
            throw "unknown extension " + value
        }

        const fileName = currentDirectory + "/" + imageDirectory + "/" + keyWithoutSpaces + extension;

        if (fs.existsSync(fileName)) {
            console.log('File exists: ' + fileName);
            continue;
        }

        for (path of paths) {
            const url = rawUrlPrefix + "/" + path + "/" + value
            try {
                console.log("trying " + url)
                console.log("destination: " + fileName)
                res = await downloadImage(url, fileName)
                console.log("done ");
                downloaded = true
            } catch (err) {
                console.log("error processing " + err)
            }
        }
        if (!downloaded) {
            console.log("ERROR: Can't find asset " + key + " val: " + value)
        }

    }

}

main()