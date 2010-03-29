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
    @total_pubs = Annotation.find_all_by_taxon_id(@taxon.id, :group => :publication_id).size
  end # show()

  def index
    @taxon_count = Taxon.count(:all)
    @annotations_by_taxon = Annotation.count(:all, :group => 'taxon_id')
    
  end

end
