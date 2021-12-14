# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.2] - 2021-12-00
### Added
- Use waitress as WSGI server
- Error fallback if image can't created

### Changed
- Booting image

### Removed
- nginx-light
- gunicorn WSGI server

## [3.1] - 2021-12-07
### Added
- Set GPU memory to 128MB -> Fix 4k screen issue

### Changed
- platform library replaced with distro

## [3.0] - 2020-10-23
### Added
- Rewrite the screenshot scripts
- Modules converted into separate services
- Simple Device Info API created
- Add readme
- Add changelog

### Changed
- Installation process
- Exclude remove/clean role

## [2.2] - 2020-06-11

### Added
- Installation script

## [2.1] - 2019-11-02

### Changed
- Update raspi2png
- Fixed error when removing the crontabs

## [2.0] - 2019-10-14

### Added
- Implement raspi2png
- Error Image


### Changed
- Change screenshot.sh functionality

## [1.1] - 2019-05-17

### Changed
- Change name to Add-On
- Expand SWAP size

## [1.0] - 2019-05-15

### Added
- Script installer
- Screenshot extension
