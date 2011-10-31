DependencyDetection.defer do
  @name = :ofsocket
  
  depends_on do
    defined?(::OFSocket) && !NewRelic::Control.instance['disable_ofsocket']
  end
  
  executes do
    NewRelic::Agent.logger.debug 'Installing OFSocket instrumentation'
  end
  
  executes do
    ::OFSocket::StompConnection.class_eval do
      add_method_tracer :receive_connect, 'OFSocket/StompConnection/receive_connect'
      add_method_tracer :receive_msg, 'OFSocket/StompConnection/receive_msg'
      add_method_tracer :send_message, 'OFSocket/StompConnection/send_message'
    end

    ::OFSocket::Services::BackEnd.class_eval do
      add_method_tracer :connects, 'OFSocket/Services/BackEnd/connects'
      add_method_tracer :disconnects, 'OFSocket/Services/BackEnd/disconnects'
    end

    ::OFSocket::Services::FrontEnd.class_eval do
      add_method_tracer :connect, 'OFSocket/Services/FrontEnd/connect'
      add_method_tracer :disconnect, 'OFSocket/Services/FrontEnd/disconnect'
      add_method_tracer :received_message_from_interconnect, 'OFSocket/Services/FrontEnd/received_message_from_interconnect'
    end
  end
end
