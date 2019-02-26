require 'wash_out/configurable'
require 'wash_out/soap_config'
require 'wash_out/soap'
require 'wash_out/engine'
require 'wash_out/param'
require 'wash_out/dispatcher'
require 'wash_out/soap'
require 'wash_out/router'
require 'wash_out/type'
require 'wash_out/model'
require 'wash_out/wsse'
require 'wash_out/middleware'

module WashOut
  def self.root
    File.expand_path '../..', __FILE__
  end
end

module ActionDispatch::Routing
  class Mapper
    # Adds the routes for a SOAP endpoint at +controller+.
    def wash_out(controller_name, base_uri=nil)
      current_scope = @scope
      scope_frames = HashWithIndifferentAccess.new
      base_uri ||= controller_name

      while current_scope
        scope_frame = (current_scope.respond_to?(:frame) ? current_scope.frame : current_scope) || HashWithIndifferentAccess.new
        scope_frames = scope_frames.deep_merge(scope_frame)
        current_scope = current_scope.parent
      end

      uri = [base_uri, scope_frames.dig(:options, :version), "ServiceBasic.svc"].compact.join("/")
      controller_class_name = [scope_frames[:module], controller_name].compact.join("/").underscore

      match "#{uri}" => "#{controller_name}#_generate_wsdl", :via => :get, :format => false
      match "#{uri}" => WashOut::Router.new(controller_class_name), :via => :post, :format => false,
            :defaults => { :controller => controller_class_name, :action => 'soap' }
    end
  end
end

Mime::Type.register "application/soap+xml", :soap
ActiveRecord::Base.send :extend, WashOut::Model if defined?(ActiveRecord)

ActionController::Renderers.add :soap do |what, options|
  _render_soap(what, options)
end

ActionController::Metal.class_eval do

  # Define a SOAP service. The function has no required +options+:
  # but allow any of :parser, :namespace, :wsdl_style, :snakecase_input,
  # :camelize_wsdl, :wsse_username, :wsse_password and :catch_xml_errors.
  #
  # Any of the the params provided allows for overriding the defaults
  # (like supporting multiple namespaces instead of application wide such)
  #
  def self.soap_service(options={})
    include WashOut::SOAP
    self.soap_config = options
  end
end

if Rails::VERSION::MAJOR >= 5
  if defined?(ActionView::Rendering)
    module ActionController
      module ApiRendering
        include ActionView::Rendering
      end
    end
  end

  ActiveSupport.on_load :action_controller do
    if self == ActionController::API
      include ActionController::Helpers
    end
  end
end
