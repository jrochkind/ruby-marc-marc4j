# encoding: UTF-8

require 'test_helper'
require 'marc/marc4j'

require 'test_helper'

describe "basics" do

  it "has a version" do
    version = MARC::MARC4J.const_get('VERSION')
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

describe "encoding" do
  before do
    @converter = MARC::MARC4J.new
  end
  
  it "outputs strings tagged as UTF8" do
    marc4j_record = nil
    File.open(support_file_path "test_data.utf8.mrc") do |file|
      reader  = org.marc4j.MarcStreamReader.new(file.to_inputstream)
      marc4j_record = reader.next
    end

    
    ruby_record   = @converter.marc4j_to_rubymarc(marc4j_record)

    ruby_record.fields.each do |field|
      if field.kind_of? MARC::DataField
        field.subfields.each do |sf|
          assert_equal sf.value.encoding.name, "UTF-8", "subfield value marked UTF-8"
        end
      else # ControlField
        assert_equal field.value.encoding.name, "UTF-8", "field value marked UTF-8"
      end
    end
  end

  describe "with a bad UTF-8 byte in marc4j" do
    before do
      File.open(support_file_path "bad_utf_byte.utf8.marc") do |file|
        reader  = org.marc4j.MarcStreamReader.new(file.to_inputstream)
        marc4j_record = reader.next
        @ruby_record   = @converter.marc4j_to_rubymarc(marc4j_record)
      end
    end
    
    
    it "replaces with replacement char in ruby-marc" do
      value = @ruby_record['300']['a']

      assert_equal  value.encoding.name, "UTF-8", "value tagged UTF-8"
      assert_equal "This is a bad byte: '\uFFFD' and another: '\uFFFD'", value, "Bad bytes replaced with \\uFFFD"
      assert        value.valid_encoding?, "value is valid encoding"
    end
  end


end

    
