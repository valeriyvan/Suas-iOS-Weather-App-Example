<p align="center">
<a href="http://imgur.com/a0IkBEX"><img src="http://i.imgur.com/a0IkBEX.png" title="source: imgur.com" /></a>
</p>
<p align="center">
<a href="https://raw.githubusercontent.com/zendesk/Suas-iOS/master/LICENSE?token=AIff-oX-dNf-KBOKyXYPRP9yto5D246gks5ZlwP7wA%3D%3D"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License" /></a>
<a href="https://gitter.im/SuasArch/Lobby?utm_source=badge&amp;utm_medium=badge&amp;utm_campaign=pr-badge&amp;utm_content=badge"><img src="https://badges.gitter.im/Join%20Chat.svg" alt="Join the chat at https://gitter.im/SuasArch/Lobby" /></a>
</p>

# Suas iOS Weather App Example

This repository contains a weather application built using [Suas](https://github.com/zendesk/Suas-iOS).

# What is Suas

[Suas](https://github.com/zendesk/Suas-iOS) is a [unidirectional data flow architecture](https://suas.readme.io/docs/why-unidirectional-architectures) implementation for iOS/macOS/tvOS/watchOS and Android heavily inspired by [Redux](http://redux.js.org). It provides an easy-to-use library that helps to create applications that are consistent, deterministic, and scalable.

Suas focuses on providing good developer experience and tooling such as [customizable logging](https://suas.readme.io/docs/logging-in-suas) and [state changes monitoring](https://suas.readme.io/docs/monitor-middleware-monitor-js).

Join our [gitter chat channel](https://gitter.im/SuasArch/Lobby) for any questions. Or check [Suas documentatation website](https://suas.readme.io).

# Requirements
- Xcode 9 and above
- Swift 3.2 and above
- [Carthage](https://github.com/Carthage/Carthage) installed

# Installation

Get the required dependencies using [Carthage](https://github.com/Carthage/Carthage) using:

```
carthage update
```

# Running the Weather App

After fetching the carthage dependencies, open `WeatherApp.xcodeproj` and run it.

# Using Suas monitor

Some of the sample apps also use [Suas Monitor middleware](https://github.com/zendesk/Suas-Monitor-Middleware) to send the state and actions to [Suas Monitor Desktop](https://travis-ci.com/zendesk/Suas-Monitor).

<p align="center">
<img src="http://i.imgur.com/QsbDsN7.gif" title="source: imgur.com" />
</p>

Head to [Suas Monitor Desktop GitHub page](https://travis-ci.com/zendesk/Suas-Monitor) for installation instruction.

After installing `Suas Monitor app` you can start visualizing your application state.

Check [Suas Monitor and the MonitorMiddleware documentation](https://suas.readme.io/docs/monitor-middleware-monitor-js) page for more in-depth information.

# Where to go next

To get more information about Suas:
- Head to [Suas website](https://suas.readme.io/docs) for more in-depth knowledge about how to use Suas.
- Check the [Suas API refrerence](https://zendesk.github.io/Suas-iOS/).
- Read through how to use Suas by checking [some examples built with Suas](https://suas.readme.io/docs/list-of-examples).
- Join the conversation on [Suas gitter channel](https://gitter.im/SuasArch/Lobby) or get in touch with the [people behind Suas](https://suas.readme.io/docs/contact-us).

# Contributing

We love any sort of contribution. From changing the internals of how Suas works, changing Suas methods and public API, changing readmes and [documentation topics](https://suas.readme.io). 

Feel free to suggest changes on the GitHub repos or directly [in Saus gitter channel](https://gitter.im/SuasArch/Lobby).

For reference check our [contributing](https://suas.readme.io/docs/contributing) guidelines.

# Suas future

To help craft Suas future releases, join us on [gitter channel](https://gitter.im/SuasArch/Lobby).