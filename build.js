const makensis = require('makensis');
const axios = require('axios');
const path = require('path');

async function doBuild() {
  try {
    const response = await axios.get('https://api.github.com/repos/cmderdev/cmder/releases/latest');
    await buildRelease(response.data.tag_name);
  } catch (error) {
    console.error(error);
  }
}

async function buildRelease(tag) {
  let options = {
    verbose: 2,
    define: {
        'CMDER_VERSION': tag
    }
  };

  console.log('Found latest tag:', tag);
  console.log('Building NSIS installer for Cmder', options.define.CMDER_VERSION);

  try {
    let output = await makensis.compile(path.join(__dirname, 'cmder_inst.nsi'), options);
    console.log(`Standard output:\n${output.stdout}`);
  } catch (output) {
    console.error(`Exit Code ${output.status}: ${output.stderr}`);
  }
}

doBuild();
