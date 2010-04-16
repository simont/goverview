# EntrezTools

require 'rubygems'
require 'memcached'
require 'bio'
require 'pp'

class EntrezTools

  $cache = Memcached.new("localhost:11211")

  def initialize(cache_prefix)
    @cache_prefix = cache_prefix || "bio"
  end

  def get_prefix(pmid)
    return "#{@cache_prefix}_#{pmid}"
  end

  def retrieve_and_cache_pmText(pmid)
    # puts "pubmed record not in cache..."
    pmText = Bio::PubMed.query(pmid)
    cache_pmText(pmText)
    return pmText
  end
  
  def cache_pmText(pmText)
    if pmText =~ /id: (\d+) Error/
      raise StandardError, "Error with \1: #{pmText}"
    end
    pmid = /PMID- (\d+)/.match(pmText)[1]
    pmid_key = "#{@cache_prefix}_#{pmid}"
    $cache.set pmid_key, pmText
    return pmid
  end
  
  def cache_delete(pmid)
    pmid_key = get_prefix(pmid)
    begin
      $cache.delete pmid_key
      return true
    rescue Memcached::NotFound
      return false
    end

  end
  
  def cached?(pmid)
    pmid_key = get_prefix(pmid)
    return $cache.get(pmid_key)
  end

  def get_pmText(pmid)
    begin
      return cached?(pmid)
      # puts "position in cache"
    rescue Memcached::NotFound
      # otherwise, get the text from PubMed and cache
      return retrieve_and_cache_pmText(pmid)
    end
  end


  def get_pmText_for_pmid_list(pmid_list)
    puts "getting bulk for #{pmid_list.size} records"
    return Bio::PubMed.efetch(pmid_list)
  end

  # Given a set of PMIDs this should go and get the PubMed text for
  # the PMIDs in blocks of chunk_size PMIDs at a time

  def get_bulk_pmText(pmids,chunk_size)
    # puts "Get bulk for #{pmids}, chunk #{chunk_size}"
    pmid_list = pmids.split(',')
    new_pmid_list = Array.new
    results = Array.new

    # first check each PMID to see if its in the cache
    pmid_list.each do |pmid|
      pmid_key = get_prefix(pmid)
      begin
        # add the info to the results if its present
        results << cached?(pmid_key)
      rescue Memcached::NotFound
        new_pmid_list << pmid
      end
    end

    # Now take the new pmids and retrieve in batches

    while !new_pmid_list.empty?
      chunk = new_pmid_list.slice!(0,chunk_size)
      new_chunk = chunk.collect {|i| i.to_i }
      # pp new_chunk
      pmText = get_pmText_for_pmid_list(new_chunk)
      begin
        results << split_bulk_pmText(pmText)
      rescue e
        pp "Problem with #{e}"
      end
      sleep 3
    end

    return results.flatten

  end # get_bulk_pmText

  def split_bulk_pmText(pmText)
    pmText.each do |p|
      begin
        cache_pmText(p)
      rescue StandardError => e
        pp "Problem with #{e.message}"
      end
    end
    
    # puts "Split #{pmText.size} records"
    
    return pmText
  end # split_bulk_pmText

end

