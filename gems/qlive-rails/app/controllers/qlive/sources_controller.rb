module Qlive
  class SourcesController < ActionController::Base

    def show
      base_path = Qlive.setup[:base_path]
      rel_path = params[:rel_path]
      path = File.expand_path("./#{rel_path}#{rel_path.end_with?('.js') ? '' : '.js'}", base_path)
      raise "Illegal path: #{path}" unless path.start_with?(base_path)
      headers['Content-Type'] = 'application/javascript'  # serve other types?  If so: (Mime::Type.lookup_by_extension(params[:format]).to_s rescue 'text/text')
      render :text => IO.read(path), :status => 200
    end

  end
end