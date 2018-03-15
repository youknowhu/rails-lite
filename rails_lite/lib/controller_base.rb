require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'byebug'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise_error
    else
      @res.header['location'] = url
      @res.status = 302
      @already_built_response = true
      @session.store_session(@res)
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise_error
    else
      @res.body = [content]
      @res['Content-Type'] = content_type
      @already_built_response = true
      @session.store_session(@res)
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    if already_built_response?
      raise_error
    else
      controller_name =  self.class.to_s.underscore
      path = "views/#{controller_name}/#{template_name}.html.erb"
      rendered_content = ERB.new(File.read(path)).result(binding)
      render_content(rendered_content, 'text/html')
      @already_built_response = true
    end
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
