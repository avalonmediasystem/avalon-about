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

require 'mediainfo'

module Avalon
  module About
    class DelayedJob < AboutPage::Configuration::Node
      attr_reader :options
      render_with 'generic_hash'

      validates_each :jobs do |record, attr, value|
        min = record.options[:min]
        max = record.options[:max]
        unless value.length.between?(min,max)
          record.errors.add attr, ": Expected between #{min} and #{max} instances; found #{value.length}"
        end
        value.each do |job|
          if job[:status] != 'running'
            record.errors.add "PID #{job[:pid]}", ": #{job[:status]}"
          end
        end
      end

      def initialize(options={})
        @options = { :pid_dir => 'tmp/pids', :min => 1, :max => 99999 }.merge(options)
      end

      def jobs
        pidfiles = Dir[File.join(Rails.root,@options[:pid_dir],'delayed_job.*.pid')].sort { |a,b| 
          File.basename(a).scan(/\d+/).first.to_i <=> File.basename(b).scan(/\d+/).first.to_i
        }
        pidfiles.collect do |pidfile|
          pid = File.read(pidfile).chomp.to_i
          status = begin
            if Process.kill(0,pid)
              'running'
            else
              'not running'
            end
          rescue Errno::ESRCH => e
            'not found'
          end
          {
            :pidfile => Pathname.new(pidfile).relative_path_from(Rails.root).to_s,
            :pid     => pid,
            :status  => status
          }
        end
      end

      def to_h
        jobs.inject({}) { |h,v|
          h[File.basename(v[:pidfile],'.pid')] = v.dup
          h
        }
      end
    end
  end
end