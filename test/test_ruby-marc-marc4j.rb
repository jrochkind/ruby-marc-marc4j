require 'helper'
require 'marc/marc4j'

class TestMarc::Marc4j < Test::Unit::TestCase

  def test_version
    version = Marc::Marc4j.const_get('VERSION')

    assert !version.empty?, 'should have a VERSION constant'
  end

end
