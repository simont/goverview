require 'spec_helper'
require 'rubygems'
require 'bio'
require 'pp'

describe Annotation do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Annotation.create!(@valid_attributes)
  end
end

describe "create new GO annotations" do
  
  before :each do
    @gaf_data = <<END
RGD	621542	Rad50		GO:0000019	RGD:1600115	ISS	UniProtKB:Q92878	P	RAD50 homolog (S. cerevisiae)		gene	taxon:10116	20080310	UniProtKB
RGD	621191	Rpl24		GO:0000027	RGD:1624291	ISO	RGD:731427	P	ribosomal protein L24		gene	taxon:10116	20100304	RGD
RGD	621191	Rpl24		GO:0000027	RGD:1600115	IEA	Ensembl:ENSMUSP00000110094	P	ribosomal protein L24		gene	taxon:10116	20100119	ENSEMBL
RGD	62025	Rps14		GO:0000028	RGD:1600115	ISS	UniProtKB:P39516	P	ribosomal protein S14		gene	taxon:10116	20060302	UniProtKB
RGD	62025	Rps14		GO:0000028	RGD:1624291	ISO	RGD:731753	P	ribosomal protein S14		gene	taxon:10116	20100305	RGD
RGD	3602	Rps6		GO:0000028	RGD:2299075|PMID:3378620	IMP		P	ribosomal protein S6		gene	taxon:10116	20080811	RGD
RGD	621024	Rps10		GO:0000028	RGD:2299075|PMID:3378620	IMP		P	ribosomal protein S10		gene	taxon:10116	20080811	RGD
RGD	62025	Rps14		GO:0000028	RGD:2299075|PMID:3378620	IMP		P	ribosomal protein S14		gene	taxon:10116	20080811	RGD
RGD	62026	Rps15		GO:0000028	RGD:2299075|PMID:3378620	IMP		P	ribosomal protein S15		gene	taxon:10116	20080811	RGD
RGD	621043	Rps25		GO:0000028	RGD:2299075|PMID:3378620	IMP		P	ribosomal protein s25		gene	taxon:10116	20080811	RGD
RGD	619887	Rps2		GO:0000028	RGD:2299075|PMID:3378620	IMP		P	ribosomal protein S2		gene	taxon:10116	20080811	RGD
RGD	71041	Pigm		GO:0000030	RGD:70624|PMID:11226175	IDA		F	phosphatidylinositol glycan anchor biosynthesis, class M		gene	taxon:10116	20050217	RGD
RGD	1309526	Pigv		GO:0000030	RGD:1600115	IEA	Ensembl:ENSP00000078527	F	phosphatidylinositol glycan anchor biosynthesis, class V		gene	taxon:10116	20100119	ENSEMBL
RGD	1586427	Pomt2		GO:0000030	RGD:1600115	IEA	InterPro:IPR003342	F	protein-O-mannosyltransferase 2		gene	taxon:10116	20100119	UniProtKB
END
  # @go_parser = Bio::GO::GeneAssociation.parser(@gaf_data)
  end
  
  it "should load annotations from GAF" do
    Bio::GO::GeneAssociation.parser(@gaf_data).each do |entry|
      lambda { Annotation.create_from_gaf(entry) }.should_not raise_error
    end
  
    Annotation.find(:all).size.should == 14
    first = Annotation.find(:first)
    first.db.should == 'RGD'
    first.aspect.should == 'P'
    first.assigned_by.should =='UniProtKB'
  
    annot_w_pmid = Annotation.find_by_db_object_id('3602')
    annot_w_pmid.db_object_symbol.should == 'Rps6'
    annot_w_pmid.db_reference.should == 'RGD:2299075|PMID:3378620'
    
  end
  
  it "should create an associated publication from a db_reference field" do
    lambda { Annotation.create_pub_from_gaf_db_reference(['RGD:2299075','PMID:3378620']) }.should_not raise_error

    pub = Publication.find(:first)
    pub.should_not == nil
    pub.pmid.should == 3378620
    Publication.find(:all).size.should == 1
  end
  
  it "should not create duplicate publication entries" do
    pub = Annotation.create_pub_from_gaf_db_reference(['RGD:2299075','PMID:3378620'])
    pub.should_not == nil
    pub.pmid.should == 3378620
    Publication.find(:all).size.should == 1
    
    pub2 = Annotation.create_pub_from_gaf_db_reference(['RGD:2299045','PMID:3378620'])
    Publication.find(:all).size.should == 1
  end
  
end

describe "create new pubs along with annotations" do
  
   before :each do
      @gaf_data = <<END
RGD	3602	Rps6		GO:0000028	RGD:2299075|PMID:3378611	IMP		P	ribosomal protein S6		gene	taxon:10116	20080811	RGD
END
  end

    it "should create publication records along with annotation records" do
      Bio::GO::GeneAssociation.parser(@gaf_data).each do |entry|
        first = Annotation.create_from_gaf(entry)
        first.db_object_symbol.should == 'Rps6'
        first.publication.pmid.should_not == nil
        first.publication.pmid.should == 3378611
      end
      
      
  end
end
