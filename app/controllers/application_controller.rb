# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter  :preload_models

  def preload_models()
    Annotation
    Publication
    Journal
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def perform_cache(key)
    logger.info "Checking for #{key}"
    begin
      unless output = CACHE.get(key)
        output = yield
        CACHE.set(key, output, 30.minutes)
      end
    rescue => e
      logger.info "MEMCACHE ERROR+++++++++++++++++++++++++++++++++++++++"
      logger.info "ERROR : #{e.message}"
      logger.info "MEMCACHE ERROR+++++++++++++++++++++++++++++++++++++++"
      output = yield
    end
    return output
  end
  
  def date_range(start)
    
    years = Hash["#{start}",0]
    this_year = Time.now().year
    while start < this_year
      start = start + 1
      years["#{start}"] = 0
    end
    
    return years
  end
  
  
end
