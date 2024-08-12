# Copyright 2011-2013, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

module Avalon
  module About
    class MediaInfo < AboutPage::Configuration::Node
      attr_reader :options

      render_with 'generic_hash'
      validates_each :version do |record, attr, value|
        if value.nil?
          record.errors.add :mediainfo, "not found at `#{record.path}`"
        end
      end

      def initialize(options={})
        @options = options
      end

      def path
        @options[:path] || "mediainfo"
      end

      def version
        `#{path} --Version`[/v([\d.]+)/, 1]
      rescue
        nil
      end

      def to_h
        { 
          'path'    => path,
          'version' => version 
        }
      end
    end
  end
end