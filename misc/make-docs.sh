#!/bin/sh -ex

mvn clean verify site

wp-publish com.io7m.xstructural.documentation/target/documentation
