# Change Log

## [v.0.1.0](https:github.com/mikecentola/cmder-inst/tree/v0.1.0) (2019-01-29)

This is the first major release that I believe is ready for *production*. Tested on my Windows 10 system. Uses GitHub API to fetch the latest version of Cmder.

### Installer

- Uses GitHub API to pull the latest version of Cmder automatically. Also removes hardcoded versioning for Cmder. [#3](https://github.com/mikecentola/cmder_inst/issues/3)
- Refactored installer to install Cmder into %LocalAppData% Programs. [#4](https://github.com/mikecentola/cmder_inst/issues/4)
- Option to add Environment Variables [#5](https://github.com/mikecentola/cmder_inst/issues/5)
- Fixed Some Installer Text Typos
- Added Installer EXE File Properties
- Fixed Uninstaller Bitmap
- Temporary downloaded files now use installer's temporary storage instead of user's `$TEMP` to ensure removal after installation.
- Changed Context Menu registry entries to use the Environment Variables
- Cleaned up uninstaller commands

### Source

- Removed API Call from build.js file
- Updated License

## [v.0.0.2](https://github.com/mikecentola/cmder-inst/tree/v0.0.2-alpha) (2019-01-08)

- Updated for Cmder v1.3.11

## [v0.0.1](https://github.com/mikecentola/cmder-inst/tree/v0.0.1-alpha) (2016-08-02)

- Initial Release