# encoding: utf-8
require 'spec_helper'

describe Base do
  it "should have https in base url by default" do
    Quandl::Client::Base.url.should include 'https://www.'
  end

  describe '.token' do
    let(:base_token) { 'foo' }

    context 'token threadsaftey disabled' do
      before(:each) do
        Quandl::Client::Base.token = base_token
      end

      context 'original thread' do
        it 'should have base value' do
          expect(Quandl::Client::Base.token).to eq(base_token)
        end

        it 'should inherit thread values' do
          thread_token = 'foobar'
          t = Thread.new do
            Quandl::Client::Base.token = thread_token
          end
          t.join
          expect(Quandl::Client::Base.token).to eq(thread_token)
        end
      end

      context 'new thread' do
        it 'should inherit base value' do
          t = Thread.new do
            expect(Quandl::Client::Base.token).to eq(base_token)
          end
          t.join
        end

        it 'should override with thread value' do
          thread_token = 'foobarbaz'
          t = Thread.new do
            Quandl::Client::Base.token = thread_token
            expect(Quandl::Client::Base.token).to eq(thread_token)
          end
          t.join
        end
      end
    end


    context 'token threadsafety enabled' do
      before(:each) do
        Quandl::Client.threadsafe_token!
        Quandl::Client::Base.token = base_token
     end

      context 'original thread' do
        it 'should have base value' do
          expect(Quandl::Client::Base.token).to eq(base_token)
        end

        it 'should not inherit thread values' do
          t = Thread.new do
            Quandl::Client::Base.token = 'hello_world!'
          end
          t.join
          expect(Quandl::Client::Base.token).to eq(base_token)
        end
      end
      context 'new thread' do
        it 'should not inherit parent value' do
          t = Thread.new do
            expect(Quandl::Client::Base.token).to be_nil
          end
          t.join
        end

        it 'should contain thread value for token' do
          thread_token = 'this_is_a_token!'
          t = Thread.new do
            Quandl::Client::Base.token = thread_token
            expect(Quandl::Client::Base.token).to eq(thread_token)
          end
          t.join
        end
      end
    end
  end
end
