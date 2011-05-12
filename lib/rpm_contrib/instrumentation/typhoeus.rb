module RpmContrib
  module Instrumentation
    module Typhoeus
      if defined?(::Typhoeus)
        require 'uri'
        module ::Typhoeus
          Request.instance_eval do
            def get_with_newrelic_trace(*args, &block)
              uri = URI.parse(args.first)
              metrics = ["External/#{uri.host}/Typhoeus/GET","External/#{uri.host}/all"]
              if NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction?
                metrics << "External/allWeb"
              else
                metrics << "External/allOther"
              end
              self.class.trace_execution_scoped metrics do
                get_without_newrelic_trace(*args, &block)
              end
            end
            alias get_without_newrelic_trace get
            alias get get_with_newrelic_trace
          end
        end
      end
    end
  end
end

