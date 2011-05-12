require 'new_relic/agent/method_tracer'

module RpmContrib
  module Instrumentation
    module UltraSphinx
      if defined?(::UltraSphinx)
        module ::Ultrasphinx
          class Search
            include NewRelic::Agent::MethodTracer

            add_method_tracer :run
            add_method_tracer :results
          end
        end
      end
    end
  end
end
