class JournalsController < ApplicationController
  
  def get_journals_for_taxon(taxon)
    rat = Hash.new()
    Annotation.find_all_by_taxon_entry(taxon, :group => :publication_id).each do |annot|
      if annot.publication
        rat.has_key?(annot.publication.journal) ? rat[annot.publication.journal] += 1 : rat[annot.publication.journal] = 1
      end
    end
    return rat
  end
  
  def index
    @journal_count = Journal.count(:all)
    top_journals_sql = "select journals.abbrev_title, journals.open_access, count(publications.journal_id) as total from journals, publications where journals.id = publications.journal_id group by journals.abbrev_title order by total desc limit 20"
    @top_journals = Journal.find_by_sql(top_journals_sql)
    @oa_journal_count = Journal.count(:conditions => "open_access != 'No' AND open_access != '0'")
    
  end
  
  # GET - displays all journals    
   def overview
      top_journals_sql = "select journals.id, journals.abbrev_title, journals.open_access, count(publications.journal_id) as total from journals, publications where journals.id = publications.journal_id group by journals.abbrev_title order by total desc limit 20"
      @top_journals = Journal.find_by_sql(top_journals_sql)
      
      @annotation_count = Annotation.count(:all)
      @publication_count = Publication.count(:all)
      @journal_count = Journal.count(:all)
      @taxon_count = Taxon.count(:all)
      @annotations_by_taxon = Annotation.count(:all, :group => 'taxon_id')
      
      # my_key = Digest::MD5.hexdigest("get_rat_journals_again")
      # rat = perform_cache(my_key) {
      #   get_journals_for_taxon('taxon:10116')
      # }
      # 
      # @rat_journals = rat.sort {|a,b| b[1]<=>a[1]}[0..99]
      # @rat_journal_total = rat.size
      
      # mouse = Hash.new()
      #    Annotation.find_all_by_taxon('taxon:10090', :group => :publication_id).each do |annot|
      #      if annot.publication
      #        mouse.has_key?(annot.publication.journal) ? mouse[annot.publication.journal] += 1 : mouse[annot.publication.journal] = 1
      #      end
      #    end
      #    @mouse_journals = mouse.sort {|a,b| b[1]<=>a[1]}[0..99]
      #    @mouse_journal_total = mouse.size
      # 
      #    yeast = Hash.new()
      #    Annotation.find_all_by_db('SGD', :group => :publication_id ).each do |annot|
      #      if annot.publication
      #        yeast.has_key?(annot.publication.journal) ? yeast[annot.publication.journal] += 1 : yeast[annot.publication.journal] = 1
      #      end
      #    end
      # 
      #    @yeast_journals = yeast.sort {|a,b| b[1]<=>a[1]}[0..99]
      #    @yeast_journal_total = yeast.size
      #  
      #   fly = Hash.new()
      #    Annotation.find_all_by_db('FB', :group => :publication_id ).each do |annot|
      #      if annot.publication
      #        fly.has_key?(annot.publication.journal) ? fly[annot.publication.journal] += 1 : fly[annot.publication.journal] = 1
      #      end
      #    end
      # 
      #    @fly_journals = fly.sort {|a,b| b[1]<=>a[1]}[0..99]
      #    @fly_journal_total = fly.size
      #    # Human
      #     
      #    human = Hash.new()
      #    Annotation.find_all_by_taxon('taxon:9606', :group => :publication_id ).each do |annot|
      #      if annot.publication
      #        human.has_key?(annot.publication.journal) ? human[annot.publication.journal] += 1 : human[annot.publication.journal] = 1
      #      end
      #    end
      # 
      #    @human_journals = human.sort {|a,b| b[1]<=>a[1]}[0..99]
      #    @human_journal_total = human.size
      #    
      #    zfin = Hash.new()
      #    Annotation.find_all_by_taxon('taxon:7955', :group => :publication_id ).each do |annot|
      #      if annot.publication
      #        zfin.has_key?(annot.publication.journal) ? zfin[annot.publication.journal] += 1 : zfin[annot.publication.journal] = 1
      #      end
      #    end
      #    
      #    @zfin_journals = zfin.sort {|a,b| b[1]<=>a[1]}[0..99]
      #    @zfin_journal_total = zfin.size
      #    
      #    wb = Hash.new()
      #    Annotation.find_all_by_taxon('taxon:6239', :group => :publication_id ).each do |annot|
      #      if annot.publication
      #        wb.has_key?(annot.publication.journal) ? wb[annot.publication.journal] += 1 : wb[annot.publication.journal] = 1
      #      end
      #    end
      #    
      #    @wb_journals = wb.sort {|a,b| b[1]<=>a[1]}[0..99]
      #    @wb_journal_total = wb.size
      #    
      #    dicty = Hash.new()
      #    Annotation.find_all_by_taxon('taxon:44689', :group => :publication_id ).each do |annot|
      #      if annot.publication
      #        dicty.has_key?(annot.publication.journal) ? dicty[annot.publication.journal] += 1 : dicty[annot.publication.journal] = 1
      #      end
      #    end
      #    
      #    @dicty_journals = dicty.sort {|a,b| b[1]<=>a[1]}[0..99]
      #    @dicty_journal_total = dicty.size
      
   end
   
   # GET - shows one pubs (based on the supplied id)    
   def show    
     @journal = Journal.find(params[:id])
     
     # using sql to grab the total number of annotations for this journal
     sql = "select annotations.aspect, count(annotations.id) as total_annots from journals, publications, annotations where journals.id = #{@journal.id} and journals.id = publications.journal_id and publications.id = annotations.publication_id group by annotations.aspect"
     results = ActiveRecord::Base.connection.execute(sql)
     @journal_annotations = Hash.new({'P' => 0,'F' => 0,'C' => 0})
     row_num = 0
     while row_num < results.num_rows
       row = results.fetch_row
       @journal_annotations[row[0]] = row[1]
       row_num += 1
     end
   end
  
end
