/* NPM build.js to automate build process with nodejs
 *
 *   Written by Eric Hocking (https://github.com/xaoseric)
 *   Written by Mike Centola (http://github.com/mikecentola)
 *
 *   Intended for NSIS 3.0

 * The MIT License (MIT)
 *
 * Copyright (c) 2021 Mike Centola, Eric Hocking
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

const NSIS = require('makensis');
const path = require('path');

const VERSION = `v${process.env.npm_package_version}`;

const options = {
    verbose: 4,
    strict: true,
    inputCharset: 'UTF8',
    define: {
        'INSTALLER_VERSION': VERSION
    } 
};

async function buildRelease() {
    await NSIS.compile(path.join(__dirname, '..', 'cmder_inst.nsi'), options)
        .then((output) => {
            console.log('Compiler output:', output);
        })
        .catch((error) => {
            console.error(error);
        })
}

void buildRelease();
