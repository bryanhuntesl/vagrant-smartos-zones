module Vagrant
  module Smartos
    module Zones
      module Util
        class Rsync
          attr_reader :connection

          def initialize(connection)
            @connection = connection
          end

          def available?
            Vagrant::Util::Subprocess.execute(*%w(which rsync)).exit_code == 0
          end

          def download(from, to)
            Vagrant::Util::Subprocess.execute(*rsync_command, '-e', ssh_command, remote(from), to, notify: [:stdout])
          end

          def upload(from, to)
            Vagrant::Util::Subprocess.execute(*rsync_command, '-e', ssh_command, from, remote(to), notify: [:stdout])
          end

          def rsync_command
            %w(rsync -avz --progress)
          end

          def ssh_command
            "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i #{identity_file} -p #{remote_port}"
          end

          def identity_file
            connection.options[:keys].first
          end

          def remote(file)
            "#{remote_user}@#{connection.host}:#{file}"
          end

          def remote_port
            connection.options[:port]
          end

          def remote_user
            connection.options[:user]
          end
        end
      end
    end
  end
end
