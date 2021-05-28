[![License](https://img.shields.io/github/license/mikecentola/cmder_inst.svg)](https://github.com/mikecentola/cmder_inst/blob/master/LICENSE) ![Version](https://img.shields.io/github/release/mikecentola/cmder_inst.svg) ![Gihub Stars](https://badgen.net/github/stars/mikecentola/cmder_inst)
[![GitHub](https://badgen.net/github/issues/mikecentola/cmder_inst)](https://github.com/appliedengdesign/vscode-gcode-syntax)

# Cmder Installer

Cmder Installer is an install executable that will fetch the latest version of Cmder online, un-pack it, and install it, using the Nullsoft Installer. It has several options including location to install to, windows explorer integration, and shorcuts.

## About Cmder

[Cmder](http://Cmder.net) is a **software package** created out of pure frustration over absence of usable console emulator on Windows. It is based on [ConEmu](https://conemu.github.io/) with *major* config overhaul, comes with a Monokai color scheme, amazing [clink](https://github.com/mridgers/clink) (further enhanced by [clink-completions](https://github.com/vladimir-kotikov/clink-completions)) and a custom prompt layout.

![Cmder Screenshot](http://i.imgur.com/g1nNf0I.png)

## Languages

Right now, Cmder Installer is only set up with English. We will be adding more languages in future releases.

## Building / Compiling

### Prerequisites

- Download [NSIS](http://nsis.sourceforge.net)
- Required NSIS Plugins
  - [inetc](https://nsis.sourceforge.io/Inetc_plug-in)
  - [ZipDLL](https://nsis.sourceforge.io/ZipDLL_plug-in)
  - [EnVar](https://nsis.sourceforge.io/EnVar_plug-in)
  - [NsJSON](https://nsis.sourceforge.io/NsJSON_plug-in)

- If using nodejs to build
  - Make sure that NSIS is properly installed with `makensis` in your PATH
  - Install nodejs / npm
  
### Build Using NSIS Gui

- Load cmder_inst.nsi into NSIS Gui Application and build

### Build using NodeJS / NPM

- `npm install`
- `npm run build`

## Contributing

For more information on contributing, please refer to our [CONTRIBUTING](https://github.com/mikecentola/cmder-inst/blob/master/CONTRIBUTING.md)

## License

All software included is bundled with own license

The MIT License (MIT)

Copyright (c) 2019 Mike Centola

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
