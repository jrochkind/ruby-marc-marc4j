require 'marc/marc4j/version'
require 'marc'

module MARC
  class MARC4J
    
    # Get a new coverter
    def initialize(opts = {})
      @logger = opts.delete(:logger)
      @jarfile = opts.delete(:jarfile)
      load_marc4j(@jarfile)
      @factory = org.marc4j.marc::MarcFactory.newInstance
    end
    
    
  
    # Given a marc4j record, return a rubymarc record
    def marc4j_to_rubymarc(marc4j)
      rmarc = MARC::Record.new
      rmarc.leader = marc4j.getLeader.marshal

      marc4j.getControlFields.each do |marc4j_control|
        rmarc.append( MARC::ControlField.new(marc4j_control.getTag(), marc4j_control.getData )  )
      end

      marc4j.getDataFields.each do |marc4j_data|
        rdata = MARC::DataField.new(  marc4j_data.getTag,  marc4j_data.getIndicator1.chr, marc4j_data.getIndicator2.chr )

        marc4j_data.getSubfields.each do |subfield|

          # We assume Marc21, skip corrupted data
          # if subfield.getCode is more than 255, subsequent .chr
          # would raise.
          if subfield.getCode > 255
            if @logger
              logger.warn("Marc4JReader: Corrupted MARC data, record id #{marc4j.getControlNumber}, field #{marc4j_data.tag}, corrupt subfield code byte #{subfield.getCode}. Skipping subfield, but continuing with record.")
            end
            next
          end

          rsubfield = MARC::Subfield.new(subfield.getCode.chr, subfield.getData)
          rdata.append rsubfield
        end

        rmarc.append rdata
      end

      return rmarc
    end
    
    
    # Given a rubymarc record, return a marc4j record
    def rubymarc_to_marc4j(rmarc)
      marc4j = @factory.newRecord(rmarc.leader)
      rmarc.each do |f|
        if f.is_a? MARC::ControlField
          new_field = @factory.newControlField(f.tag, f.value)
        else
          new_field = @factory.new_data_field(f.tag, f.indicator1.ord, f.indicator2.ord)
          f.each do |sf|
            new_field.add_subfield(@factory.new_subfield(sf.code.ord, sf.value))
          end
        end
        marc4j.add_variable_field(new_field)
      end
      return marc4j
    end
    
    
    private
    # Load up the jar if we need it
    def load_marc4j(jarfile = nil)
      unless defined?(org.marc4j.marc::MarcFactory)
        require_marc4j_jar(jarfile)
      end
    end

    # Try to get the specified jarfile, or the bundled one if nothing is specified
    def require_marc4j_jar(jarfile)
      unless defined? JRUBY_VERSION
        raise LoadError.new, "MARC::MARC4J requires the use of JRuby", nil
      end
      if jarfile
        require jarfile
      else
        require_relative '../../ext/marc4j/lib/marc4j-2.5.1-beta.jar'
      end
    end
  end
end
