# Changelog

## [1.5.3] - 2018-04-14

### Added

- Updated gemspec meta information to include documentation link

## [1.5.2] - 2018-04-14

### Added

- Updated gemspec meta information to include homepage, source code links

## [1.5.1] - 2018-04-14

### Fixed

- Fixed bug that did not update Near Earth Object id when selecting object based on number

## [1.5.0] - 2018-04-14

### Added

- All information about Near Earth Objects can be returned, including all close approach data held on the object (Does require an additional API call within the gem to retrieve the verbose data). Added #neo_data_verbose method to .Client
- Updated README.md to include suggest environment variable for API key, new usage instructions for above method

## [1.4.0] - 2018-04-14

### Added

- Ability to see how many calls are remaining with your current API key. Added #calls_remaining method to .Client
