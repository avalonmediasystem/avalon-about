require 'about_page'
require "avalon/about/engine"
require "avalon/about/version"

module Avalon
  module About
    autoload :DelayedJob, "avalon/about/delayed_job"
    autoload :Matterhorn, "avalon/about/matterhorn"
    autoload :MediaInfo,  "avalon/about/media_info"
  end
end
