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

require 'timeout'
require 'socket'

module Avalon
  module About
    class RTMPServer < AboutPage::Configuration::Node
      PROTOCOL_VERSION = 3
      EPOCH_TIMESTAMP  = [5, 16, 90, 239]

      render_with 'generic_hash'
      attr_accessor :server, :port, :timeout

      validates_each :status do |record, attr, value|
        if value != 'alive'
          record.errors.add attr, ": #{value}"
        end
      end

      def initialize(server,options={})
        @server  = server
        @port    = options[:port] || 1935
        @timeout = options[:timeout] || 2
      end

      def status
        ping
        'alive'
      rescue Exception => e
        e.message
      end

      def to_h
        { @server => status }
      end

      def ping
        Timeout.timeout(@timeout) do
          c0 = [PROTOCOL_VERSION].pack('C*')
          c1 = EPOCH_TIMESTAMP.dup
          c1 << rand(255) while c1.length < 1536
          c1 = c1.pack('C*')
          s = TCPSocket.new @server, @port
          s.write(c0)
          s.write(c1)
          s0 = s.read(1)
          raise "Bad protocol version" if s0 != c0
          s1 = s.read(1536)
          s.write(s1)
          s2 = s.read(1536)
          raise "Bad handshake" if s2[8..-1] != c1[8..-1]
          s.close
          return true
        end
      end

    end
  end
end
