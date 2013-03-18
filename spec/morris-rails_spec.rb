require 'spec_helper'

describe Dummy::Application do
  
  it 'should find `jquery.cookie` as an asset' do
    described_class.assets['morris'].should_not be_nil
  end
  
  it 'should have the correct body for `jquery.cookie`' do
    described_class.assets['morris'].body.should include('jquery-cookie')
  end
end
