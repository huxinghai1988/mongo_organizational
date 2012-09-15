require File.expand_path("../../spec_helper", __FILE__)
require File.expand_path('../mongodb_server', __FILE__)


describe "mongodb standlle server multithread " do 
  before(:all) do
    @queue = Queue.new
    MongodbServer.start_server(@queue)
    @port = @queue.pop
    @companies = %w(apple microsoft yahoo facebook amazon intel orcale google sony samsung)
  end

  it "get root index" do
    require 'net/http'
    THREADS_COUNT = 10

    queue = Queue.new

    revert_thread = Thread.new do 
      100.times do
        result = queue.pop
        index = result.index
        total = result.total
        organization = result.organization
        body = result.body
        hash = JSON.parse(body)
        total.should eq(hash["order"]["total"].to_i)
        index.should eq(hash["order"]["index"].to_i)
        organization.should eq(hash["order"]["database"].gsub(/_(test|development|production)$/, ''))

        # puts "organization: #{organization} index: #{index} total: #{total} body: #{body}"
      end
    end

    COUNT = 10

    threads =  (0..THREADS_COUNT).map.with_index do |i|
      Thread.new(i) do |index|
        index = index * COUNT 
        COUNT.times do 
          index +=  1

          Net::HTTP.start('localhost', @port) do |http|
            organization = @companies[rand(10)]
            total = rand(100000)

            data = {:index => index, :total => total}.map{|k,v|"#{k}=#{v}"}.join('&')
            url = "/organizational/#{organization}"
            response = http.post(url, data)
            queue << OpenStruct.new(:index => index, :total => total, :organization => organization, :body => response.body)
          end
        end
      end
    end

    threads.each { |t| t.join }

    revert_thread.join

  end
  
end

