module Fog
  module Linode
    extend Fog::Service

    requires :linode_api_key

    model_path 'fog/linode/models'

    request_path 'fog/linode/requests'
    request 'avail_datacenters'
    request 'avail_distributions'
    request 'avail_kernels'
    request 'avail_linodeplans'

    class Mock
      include Collections

      def self.data
        @data ||= Hash.new do |hash, key|
          hash[key] = {}
        end
      end

      def self.reset_data(keys=data.keys)
        for key in [*keys]
          data.delete(key)
        end
      end

      def initialize(options={})
        @linode_api_key = options[:linode_api_key]
        @data = self.class.data[@linode_api_key]
      end

    end

    class Real
      include Collections

      def initialize(options={})
        @linode_api_key = options[:linode_api_key]
        @host   = options[:host]    || "api.linode.com"
        @port   = options[:port]    || 443
        @scheme = options[:scheme]  || 'https'
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
      end

      def reload
        @connection.reset
      end

      def request(params)
        params[:query] ||= {}
        params[:query].merge!(:api_key => @linode_api_key)

        begin
          response = @connection.request(params.merge!({:host => @host}))
        rescue Excon::Errors::Error => error
          raise case error
          when Excon::Errors::NotFound
            Fog::Linode::NotFound.slurp(error)
          else
            error
          end
        end

        unless response.body.empty?
          response.body = JSON.parse(response.body)
        end
        response
      end

    end
  end
end
