/* NPM build.js to automate build process with nodejs
 *
 *   Written by Eric Hocking (https://github.com/xaoseric)
 *   Written by Mike Centola (http://github.com/mikecentola)
 *
 *   Intended for NSIS 3.0

 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Mike Centola, Eric Hocking
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

const VERSION = process.env.npm_package_version;

const makensis = require('makensis');
const axios = require('axios');
const path = require('path');

async function buildRelease() {
  let options = {
    verbose: 2,
    define: {
        'INSTALLER_VERSION': VERSION
    }
  };
  
  console.log('Cmder Installer Version: ', VERSION);
  console.log('Found latest tag:', tag);
  console.log('Building NSIS installer for Cmder');

  try {
    let output = await makensis.compile(path.join(__dirname, 'cmder_inst.nsi'), options);
    console.log(`\n${output.stdout}`);
  } catch (output) {
    console.error(`Exit Code ${output.status}: ${output.stderr}`);
  }
}

buildRelease();
