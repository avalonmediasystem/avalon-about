# Avalon::About

Node classes for use with [about_page](https://github.com/sul-dlss/about_page) to
monitor [Avalon Media System](https://github.com/avalonmediasystem/avalon) components:

* Database connection
* Opencast Matterhorn server
* RTMP streaming server
* MediaInfo
* Delayed Job processes
* Resque processes

## Installation

Add the following line to your application's Gemfile:

    gem 'avalon-about'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install avalon-about

## Usage

Follow the [about_page usage instructions](https://github.com/sul-dlss/about_page/blob/master/README.md) to get a basic about page up and running. Then add one or more
of the additional node types provided by `Avalon::About`:

    config.database         = Avalon::About::Database.new(OneOfMyModels)
    config.matterhorn       = Avalon::About::Matterhorn.new(Rubyhorn)
    config.mediainfo        = Avalon::About::MediaInfo.new(:path => '/usr/bin/mediainfo')
    config.streaming_server = Avalon::About::RTMPServer.new(streaming_server_host)
    config.delayed_job      = Avalon::About::DelayedJob.new(:min => 1)
    config.resque           = Avalon::About::Resque.new(::Resque)
    config.resque_scheduler = Avalon::About::ResqueScheduler.new(::Resque::Scheduler)
