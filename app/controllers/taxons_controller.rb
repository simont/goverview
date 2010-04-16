class TaxonsController < ApplicationController


  def get_journals_for_taxon(taxon)
    journals = Hash.new()
    Annotation.find_all_by_taxon_id(@taxon.id, :group => :publication_id).each do |annot|
      if annot.publication
        journals.has_key?(annot.publication.journal) ? journals[annot.publication.journal] += 1 : journals[annot.publication.journal] = 1
      end
    end
    return journals
  end # get_journals_for_taxon(taxon)

  # GET - displays individual taxon report
  def show

    @taxon = Taxon.find(params[:id])

    my_key = Digest::MD5.hexdigest("get_#{@taxon.genus}_#{@taxon.species}_journals")
    journals = perform_cache(my_key) {
      get_journals_for_taxon(@taxon)
    }

    @journals = journals.sort {|a,b| b[1]<=>a[1]}[0..99]
    @journals_total = journals.size
    taxon_annots = Annotation.find_all_by_taxon_id(@taxon.id, :group => :publication_id)
    @total_pubs = taxon_annots.size
    
    pubs =  Hash.new() #Publication.count(:all, :group => "YEAR(year)")
    
    taxon_annots.each do |annot|
      next unless annot.publication != nil && annot.publication.year != nil
      pub = annot.publication
      pubs.has_key?(pub.year.year) ? pubs[pub.year.year] = pubs[pub.year.year] + 1 : pubs[pub.year.year] = 1
    end
    
    
    pubs.delete(nil)
    pubs.delete("0")
    first_year = pubs.keys.sort.first
    @pub_history = date_range(first_year)
    pubs.each do |year,total|
      @pub_history["#{year}"] = total
    end
    
    # This would be a faster (non-Active Record) way to do get the pubs per year for each taxon, the current way is verry slow.  
    # pubs_per_year_sql = "select YEAR(publications.year), count(distinct annotations.publication_id) from annotations, publications where annotations.taxon_id = #{@taxon.id} and annotations.publication_id = publications.id group by YEAR(publications.year)"
    # @pubs_per_year = Publication.find_by_sql(pubs_per_year_sql)
    
  end # show()

  def index
    @taxon_count = Taxon.count(:all)
    @annotations_by_taxon = Annotation.count(:all, :group => 'taxon_id')
    
  end
  
end
