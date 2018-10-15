require 'spec_helper'

describe 'sendmail::canonify_array' do
  context 'with arg => []' do
    it {
      is_expected.to run.with_params([]).and_return([])
    }
  end

  context "with arg => ['foo']" do
    it {
      is_expected.to run.with_params(['foo']).and_return(['foo'])
    }
  end

  context "with arg => ['foo ']" do
    it {
      is_expected.to run.with_params(['foo ']).and_return(['foo'])
    }
  end

  context "with arg => [' foo']" do
    it {
      is_expected.to run.with_params([' foo']).and_return(['foo'])
    }
  end

  context "with arg => [' foo ']" do
    it {
      is_expected.to run.with_params([' foo ']).and_return(['foo'])
    }
  end

  context "with arg => ['foo','bar']" do
    it {
      is_expected.to run.with_params(['foo', 'bar']).and_return(['bar', 'foo'])
    }
  end

  context "with arg => ['foo','foo']" do
    it {
      is_expected.to run.with_params(['foo', 'foo']).and_return(['foo'])
    }
  end

  context "with arg => ['foo','bar','baz']" do
    it {
      is_expected.to run.with_params(['foo', 'bar', 'baz']).and_return(['bar', 'baz', 'foo'])
    }
  end
end
