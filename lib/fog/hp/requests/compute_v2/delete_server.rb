module Fog
  module Compute
    class HPV2
      class Real

        # Delete an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of the server to delete
        #
        def delete_server(server_id)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path   => "servers/#{server_id}"
          )
        end

      end

      class Mock

        def delete_server(server_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].detect {|_| _['id'] == server_id}
            if server['status'] == 'BUILD'
              response.status = 409
              raise(Excon::Errors.status_error({:expects => 202}, response))
            else
              self.data[:last_modified][:servers].delete(server_id)
              self.data[:servers].delete(server_id)
              response.status = 204
            end
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end

      end
    end
  end
end
