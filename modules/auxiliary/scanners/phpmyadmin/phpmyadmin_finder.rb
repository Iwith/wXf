#!/usr/bin/env ruby
# 
# Created Oct 9 2011
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

#include WXf::WXfassists::General::PooledReq
include WXf::WXfassists::General::MechReq
  require 'celluloid'
class Fetcher
	include Celluloid

	def get(action, params)
		puts "Doing Work..."
		res = action.call(params)
		puts res.inspect
		return res
		rescue Exception => e
			return ""
	end
end

  def initialize
      super(
        'Name'        => 'phpMyAdmin Finder',
        'Version'     => '1.0',
        'Description' => %q{
          Enumerates several common install locations, searching for phpMyAdmin                    },
        'References'  =>
        [
          [ 'URL', 'http://packetstormsecurity.org/files/view/102681/phpmyadmin-finder.txt' ],
        ],
        'Author'      => [ 'Bl4ck.Viper', 'John Poulin' ],
        'License'     => WXF_LICENSE

      )
   
      init_opts([
		OptString.new('VERBOSE', [false, "Show verbose output?", false])
      ])
  
  end
  
  def run
	dirs = Array[
"/phpMyAdmin/",
"/phpmyadmin/",
"/PMA/",
"/pma/",
"/db/",
"/admin/",
"/dbadmin/",
"/mysql/",
"/myadmin/",
"/phpmyadmin2/",
"/phpMyAdmin2/",
"/phpMyAdmin-2/",
"/php-my-admin/",
"/phpMyAdmin-master-latest/",
"/phpMyAdmin-2.2.3/",
"/phpMyAdmin-2.2.6/",
"/phpMyAdmin-2.5.1/",
"/phpMyAdmin-2.5.4/",
"/phpMyAdmin-2.5.5-rc1/",
"/phpMyAdmin-2.5.5-rc2/",
"/phpMyAdmin-2.5.5/",
"/phpMyAdmin-2.5.5-pl1/",
"/phpMyAdmin-2.5.6-rc1/",
"/phpMyAdmin-2.5.6-rc2/",
"/phpMyAdmin-2.5.6/",
"/phpMyAdmin-2.5.7/",
"/phpMyAdmin-2.5.7-pl1/",
"/phpMyAdmin-2.6.0-alpha/",
"/phpMyAdmin-2.6.0-alpha2/",
"/phpMyAdmin-2.6.0-beta1/",
"/phpMyAdmin-2.6.0-beta2/",
"/phpMyAdmin-2.6.0-rc1/",
"/phpMyAdmin-2.6.0-rc2/",
"/phpMyAdmin-2.6.0-rc3/",
"/phpMyAdmin-2.6.0/",
"/phpMyAdmin-2.6.0-pl1/",
"/phpMyAdmin-2.6.0-pl2/",
"/phpMyAdmin-2.6.0-pl3/",
"/phpMyAdmin-2.6.1-rc1/",
"/phpMyAdmin-2.6.1-rc2/",
"/phpMyAdmin-2.6.1/",
"/phpMyAdmin-2.6.1-pl1/",
"/phpMyAdmin-2.6.1-pl2/",
"/phpMyAdmin-2.6.1-pl3/",
"/phpMyAdmin-2.6.2-rc1/",
"/phpMyAdmin-2.6.2-beta1/",
"/phpMyAdmin-2.6.2-rc1/",
"/phpMyAdmin-2.6.2/",
"/phpMyAdmin-2.6.2-pl1/",
"/phpMyAdmin-2.6.3/",
"/phpMyAdmin-2.6.3-rc1/",
"/phpMyAdmin-2.6.3/",
"/phpMyAdmin-2.6.3-pl1/",
"/phpMyAdmin-2.6.4-rc1/",
"/phpMyAdmin-2.6.4-pl1/",
"/phpMyAdmin-2.6.4-pl2/",
"/phpMyAdmin-2.6.4-pl3/",
"/phpMyAdmin-2.6.4-pl4/",
"/phpMyAdmin-2.6.4/",
"/phpMyAdmin-2.7.0-beta1/",
"/phpMyAdmin-2.7.0-rc1/",
"/phpMyAdmin-2.7.0-pl1/",
"/phpMyAdmin-2.7.0-pl2/",
"/phpMyAdmin-2.7.0/",
"/phpMyAdmin-2.8.0-beta1/",
"/phpMyAdmin-2.8.0-rc1/",
"/phpMyAdmin-2.8.0-rc2/",
"/phpMyAdmin-2.8.0/",
"/phpMyAdmin-2.8.0.1/",
"/phpMyAdmin-2.8.0.2/",
"/phpMyAdmin-2.8.0.3/",
"/phpMyAdmin-2.8.0.4/",
"/phpMyAdmin-2.8.1-rc1/",
"/phpMyAdmin-2.8.1/",
"/phpMyAdmin-2.8.2/",
"/phpMyAdmin-3.3.10.1/",
"/phpMyAdmin-3.3.10/",
"/phpMyAdmin-3.3.10.3/",
"/phpMyAdmin-3.3.10.4/",
"/phpMyAdmin-3.4.6-rc1/",
"/phpMyAdmin-3.4.5/",
"/phpMyAdmin-3.4.4/",
"/phpMyAdmin-3.4.3.2/",
"/phpMyAdmin-3.4.3.1/",
"/phpMyAdmin-3.4.3/",
"/phpMyAdmin-3.4.2/",
"/phpMyAdmin-3.4.1/",
"/phpMyAdmin-3.4.0/",
"/phpMyAdmin-3.5.0/",
"/phpMyAdmin-3.5.1/",
"/phpMyAdmin-3.5.2/",
"/phpMyAdmin-3.5.2.2/",
"/phpMyAdmin-2.1.0/",
"/phpMyAdmin-2.0.5/",
"/phpMyAdmin-1.3.0/",
"/phpMyAdmin-1.1.0/",
"/phpMyAdmin-3.3.9.2/",
"/phpMyAdmin-2.11.11.3/",
"/phpMyAdmin-3.3.9.1/",
"/phpMyAdmin-3.3.9/",
"/phpMyAdmin-3.3.8.1/",
"/phpMyAdmin-2.11.11.1/",
"/phpMyAdmin-3.3.8/",
"/phpMyAdmin-3.3.7/",
"/phpMyAdmin-2.11.11/",
"/phpMyAdmin-3.3.6/",
"/phpMyAdmin-3.3.5.1/",
"/phpMyAdmin-2.11.10.1/",
"/sqlmanager/",
"/mysqlmanager/",
"/p/m/a/",
"/PMA2005/",
"/pma2005/",
"/phpmanager/",
"/php-myadmin/",
"/phpmy-admin/",
"/webadmin/",
"/sqlweb/",
"/websql/",
"/webdb/",
"/mysqladmin/",
"/mysql-admin/"
	]

pool = Fetcher.pool(size: 100)

dirs.each { |dirname|
	url = rurl + dirname
	options = {
		'method' 	=> "GET",
		'UA'		=> datahash['UA'],
		'RURL'		=> url,
		'DEBUG'		=> 'log'
	}

	pool.future.get(Proc.new {|opts| mech_req(opts)}, options) 

=begin

	url = rurl + dirname

# Prepare Options
	req_opts = {
    	'method' => "GET",
    	'RURL'=> url,
    	'DEBUG' => 'log'
    }
p.add(req_opts)
=end

=begin


		res = mech_req({
            'method' => "GET",
            'UA' => datahash['UA'],
            'RURL'=> url,
            'DEBUG' => 'log'
          })

		if res and res.respond_to?('code')
			code = res.code
		else
			code = res
		end

		# Look at code and output status
		case code
			when 200, 401, 403, "200", "401", "403"
				print_good(code.to_s + ": " + url)
			else
				if datahash['VERBOSE'] == "true"
					print_error("#{code}: " + url)
				end
		end
=end
}
  end
  
end
