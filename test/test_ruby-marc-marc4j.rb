# encoding: UTF-8

require 'test_helper'
require 'marc/marc4j'

require 'test_helper'

describe "basics" do

  it "has a version" do
    version = Marc::Marc4j.const_get('VERSION')
    assert !version.empty?, 'should have a VERSION constant'
  end

end


describe "loads" do
  it "Loads the default on init" do
    converter = MARC::MARC4J.new
    assert defined?(org.marc4j.marc::MarcFactory), "Default jar file got loaded"
  end
  
  it "Loads a specific jar file" do
    converter = MARC::MARC4J.new(:jardir => ext_file_path('marc4j/lib'))
    assert defined?(org.marc4j.marc::MarcFactory), "Specific jar file got loaded"
  end
end

describe "round trips" do
  before do
    @file = support_file_path('test_data.utf8.mrc')
    @converter = MARC::MARC4J.new
  end
  
  it "round trips starting with ruby-marc" do
    reader = MARC::Reader.new(@file)
    reader.each do |r1|
      marc4j = @converter.rubymarc_to_marc4j(r1)
      r2 = @converter.marc4j_to_rubymarc(marc4j)
      assert_equal r1, r2, "Ruby records match on record #{r1['001'].value}"
    end
  end
  
  # Need to actually check against ruby-marc records, since marc4j doesn't have a good ==
  it "round trips starting with marc4j" do
    reader = org.marc4j:: MarcPermissiveStreamReader.new(File.open(@file).to_inputstream, true, true)
    while reader.has_next?
      m1 = reader.next
      r1 = @converter.marc4j_to_rubymarc(m1)
      m2 = @converter.rubymarc_to_marc4j(r1)
      r2 = @converter.marc4j_to_rubymarc(m1)
      assert_equal r1, r2, "Marc4j records match on record #{r1['001'].value}"
    end
  end
  
end

    
