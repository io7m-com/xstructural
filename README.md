xstructural
===

[![Maven Central](https://img.shields.io/maven-central/v/com.io7m.xstructural/com.io7m.xstructural.svg?style=flat-square)](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22com.io7m.xstructural%22)
[![Maven Central (snapshot)](https://img.shields.io/nexus/s/com.io7m.xstructural/com.io7m.xstructural?server=https%3A%2F%2Fs01.oss.sonatype.org&style=flat-square)](https://s01.oss.sonatype.org/content/repositories/snapshots/com/io7m/xstructural/)
[![Codecov](https://img.shields.io/codecov/c/github/io7m-com/xstructural.svg?style=flat-square)](https://codecov.io/gh/io7m-com/xstructural)

![com.io7m.xstructural](./src/site/resources/xstructural.jpg?raw=true)

| JVM | Platform | Status |
|-----|----------|--------|
| OpenJDK (Temurin) Current | Linux | [![Build (OpenJDK (Temurin) Current, Linux)](https://img.shields.io/github/actions/workflow/status/io7m-com/xstructural/main.linux.temurin.current.yml)](https://www.github.com/io7m-com/xstructural/actions?query=workflow%3Amain.linux.temurin.current)|
| OpenJDK (Temurin) LTS | Linux | [![Build (OpenJDK (Temurin) LTS, Linux)](https://img.shields.io/github/actions/workflow/status/io7m-com/xstructural/main.linux.temurin.lts.yml)](https://www.github.com/io7m-com/xstructural/actions?query=workflow%3Amain.linux.temurin.lts)|
| OpenJDK (Temurin) Current | Windows | [![Build (OpenJDK (Temurin) Current, Windows)](https://img.shields.io/github/actions/workflow/status/io7m-com/xstructural/main.windows.temurin.current.yml)](https://www.github.com/io7m-com/xstructural/actions?query=workflow%3Amain.windows.temurin.current)|
| OpenJDK (Temurin) LTS | Windows | [![Build (OpenJDK (Temurin) LTS, Windows)](https://img.shields.io/github/actions/workflow/status/io7m-com/xstructural/main.windows.temurin.lts.yml)](https://www.github.com/io7m-com/xstructural/actions?query=workflow%3Amain.windows.temurin.lts)|

## xstructural

XSLT implementation of the structural documentation format.

## Features

* Extremely simple core language with roughly ~20 elements. Easy to learn!
* DocBook-like semantic tagging of terms without the need to memorize hundreds
  of XML elements.
* Automatic tables of content, section and paragraph numbering.
* Full, strict XSD schema with mandatory validation of documents.
* XHTML Strict 1.0 output, in single or multi-page forms.
* EPUB output.
* Produces valid and strongly accessible XHTML, with captions and metadata for
  screen readers. Tools automatically validate their own output and refuse to
  produce invalid output.
* Written in Java 17 for platform independence.
* Fully documented command line tools for document processing.
* Maven plugin for processing documentation as part of a project build.
* Large, high-coverage test suite.
* [OSGi-ready](https://www.osgi.org/)
* [JPMS-ready](https://en.wikipedia.org/wiki/Java_Platform_Module_System)
* ISC license.

## Usage

See the [documentation](https://www.io7m.com/software/xstructural).

