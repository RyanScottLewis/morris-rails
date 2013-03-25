require 'spec_helper'

describe Dummy::Application do
  
  it 'should find `morris` as an asset' do
    described_class.assets['morris'].should_not be_nil
  end
  
  it 'should find `morris.area` as an asset' do
    described_class.assets['morris.area'].should_not be_nil
  end
  
  it 'should find `morris.bar` as an asset' do
    described_class.assets['morris.bar'].should_not be_nil
  end
  
  it 'should find `morris.donut` as an asset' do
    described_class.assets['morris.donut'].should_not be_nil
  end
  
  it 'should find `morris.grid` as an asset' do
    described_class.assets['morris.grid'].should_not be_nil
  end
  
  it 'should find `morris.hover` as an asset' do
    described_class.assets['morris.hover'].should_not be_nil
  end
  
  it 'should find `morris.line` as an asset' do
    described_class.assets['morris.line'].should_not be_nil
  end
  
  it 'should find `morris.core` as an asset' do
    described_class.assets['morris.core'].should_not be_nil
  end
  
end
