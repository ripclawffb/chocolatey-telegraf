# Chocolatey InfluxData Telegraf

[![Build status](https://ci.appveyor.com/api/projects/status/v4x7i5epnpytu95p/branch/master?svg=true)](https://ci.appveyor.com/project/ripclawffb/chocolatey-telegraf/branch/master)

This repository contains the chocolatey install scripts and nuspec file to install telegraf on Windows.

## Why use Telegraf?
Collect and send all kinds of data:

**Database:** Connect to datasources like MongoDB, MySQL, Redis, and others to collect and send metrics.
Systems: Collect metrics from your modern stack of cloud platforms, containers, and orchestrators.
IoT sensors: Collect critical stateful data (pressure levels, temp levels, etc.) from IoT sensors and devices.
Agent: Telegraf can collect metrics from a wide array of inputs and write them into a wide array of outputs. It is plugin-driven for both collection and output of data so it is easily extendable. It is written in Go, which means that it is a compiled and standalone binary that can be executed on any system with no need for external dependencies, no npm, pip, gem, or other package management tools required.

**Coverage:** With over 200+ plugins already written by subject matter experts on the data in the community, it is easy to start collecting metrics from your end-points. Even better, the ease of plugin development means you can build your own plugin to fit with your monitoring needs. You can even use Telegraf to parse the input data formats into metrics. These include: InfluxDB Line Protocol, JSON, Graphite, Value, Nagios, and Collectd.

**Flexible:** The Telegraf plugin architecture supports your processes and does not force you to change your workflows to work with the technology. Whether you need it to sit on the edge, or in a centralized manner, it just fits with your architecture instead of the other way around. Telegraf’s flexibility makes it an easy decision to implement.
