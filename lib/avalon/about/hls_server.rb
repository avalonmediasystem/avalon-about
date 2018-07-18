# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
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

require "net/https"
require "uri"

module Avalon
  module About
    class HLSServer < AboutPage::Configuration::Node

      render_with 'generic_hash'
      attr_accessor :server, :port, :protocol, :timeout

      validates_each :status do |record, attr, value|
        if value != 'alive'
          record.errors.add attr, ": #{value}"
        end
      end

      def initialize(hls_base,options={})
        uri = URI.parse(hls_base)
        @server  = uri.host
        @port = uri.port
        @protocol = uri.scheme

        @timeout = options[:timeout] || 2
      end

      def status
        'alive' if ping == "200"
      rescue Exception => e
        e.message
      end

      def to_h
        { @server => status }
      end

      def ping
        Timeout.timeout(@timeout) do
          http = Net::HTTP.new(@server, @port)
          http.use_ssl = true if @protocol == "https"

          request = Net::HTTP::Get.new("/")
          res = http.request(request)

          return res.code
        end
      end

    end
  end
end
