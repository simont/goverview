class PublicationsController < ApplicationController
  
  # GET - displays all pubs    
   def index
      top_pubs_sql = "select publications.title, count(annotations.id) as total from publications, annotations where annotations.publication_id = publications.id group by publications.id order by total desc limit 20"
      # result = ActiveRecord::Base.connection.select_rows(need_sql)
      @top_pubs = Publication.find_by_sql(top_pubs_sql)
      @publication_count = Publication.count(:all) 
      
      my_key = Digest::MD5.hexdigest("get_pubs_by_taxon")
      @publications_by_taxon = perform_cache(my_key) {
        Annotation.count('publication_id', :distinct=> "true", :group => "taxon_id")
      }
   end
   
   # GET - shows one pubs (based on the supplied id)    
   def show    
     @publication = Publication.find(params[:id])
   end
   
   
end
