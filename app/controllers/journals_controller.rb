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
      
      pubs =  Publication.count(:all, :group => "YEAR(year)")
      
      # kludge to get rid of invalide data that will mess up the sort
      pubs.delete(nil)
      pubs.delete("0")
      
      # get the earliest publication year
      first_year = pubs.keys.sort.first.to_i
      @pub_history = date_range(first_year)
      @pub_history_last_twenty_years =  Hash.new()
      pubs.each do |year,total|
        @pub_history["#{year}"] = total
        if year.to_i > Time.now().year - 20
          @pub_history_last_twenty_years["#{year}"] = total
        end
      end
      
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
