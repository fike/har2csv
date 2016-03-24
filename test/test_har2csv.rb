require 'test/unit'
require 'har2csv'



class Har2csvTest < Minitest::test
  def test_har_file
      har2csv www.fernandoike.com.har
      if $?.exitstatus != 0
        raise "Someting failed in the test"
      end
  end
end
