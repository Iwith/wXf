require 'wXf/wXfui'

begin
  require 'rubygems'
  require 'mechanize'
rescue LoadError
end

module WXf
module WXfassists
module General
module MechReq
     
      attr_accessor :rce, :rce_code

      #
      # Global Options are created
      #
      def initialize(hash_info={})
        @@count = 0 

        super
            init_opts([
              WXf::WXfmod_Factory::OptString.new('RURL',   [true, 'Target address', 'http://www.example.com/test.php']),
              WXf::WXfmod_Factory::OptString.new('PROXYA', [false, 'Proxy IP Address', '']),
              WXf::WXfmod_Factory::OptString.new('PROXYP', [false, 'Proxy Port Number', '']),
              WXf::WXfmod_Factory::OptInteger.new('THROTTLE', [false, 'Specify a number, after x requests we pause', 0 ])
           ])           
     end
     
     
     def rurl
      datahash['RURL']
     end
     
     def proxyp
      datahash['PROXYP']
     end
     
     def proxya
       datahash['PROXYA']
     end
     
     #
     # Added to solve throttling issues
     #
     def throttle
       datahash['THROTTLE']
     end
    
     #
     # Had to add this so that when an interrupt occurs we reset the counter
     # ...to 0. It is extremely important. It makes throttling work.
     #
     def self.count(cnt)
       @@count = cnt
     end  

=begin       
      # [RURL]
      # [PROXYA]
      # [PROXYP]
      # [DEBUG]
      # [UA]
      # [BASIC_AUTH_USER]
      # [BASIC_AUTH_PASS]
      # [GET, POST, PUT, HEAD, DELETE]
      # [RFILE]
      # [RFILECONTENT]
      # [CAFILE]
      # [KEEP-ALIVE]
      # [RPARAMS]
      # [HEADERS]
      # [REDIRECT]


   all agent methods
  
  #add_to_history
  #auth
  #back
  #basic_auth
  #click
  #cookies
  #current_page
  #delete
  #fetch_page
  #get
  #get_file
  #head
  #log
  #log=
  #max_history
  #max_history=
  #page
  #post
  #post_connect_hooks
  #post_form
  #pre_connect_hooks
  #put
  #request_with_entity
  #resolve
  #set_proxy
  #submit
  #transact
  #user_agent_alias=
  #visited?
  #visited_page 
    
=end        
      
    
      #
      # An agent object is instantiated (Mechanize) and debugging is determined
      #
      def mech_req(opts={})

		# Can we wrap this into celluloid

        # Add a 1, simple right?
        @@count += 1 
        
        debug = opts['DEBUG']
        agent = nil
        
        begin
          case debug
          # This represents output to the console  
          when 'console'
            agent = Mechanize.new {|a|  a.log = Logger.new(STDERR)}
          # This represents writing to agent.log in the logs directory
          when 'log'
          file = "#{LogsDir}agent.log"
          if File.exist?(file)
            File.delete(file)
          end
            agent = Mechanize.new {|a|  a.log = Logger.new(file)}    
              
          else
            agent = Mechanize.new {|a| a.log = Logger.new(false)}
          end 
        end     
       
        if @@count > 0 and @@count == throttle
            prnt_plus("sleep 3 seconds")
            sleep(3)
            @@count = 0
            req_sequence(opts, agent)
        else
          req_sequence(opts, agent)
        end
        
        
         
      end
      
      
   
      
    #
    # Determines method and process based off this information   
    #
    def req_sequence(opts, agent)         
      
          # Request object cleared/init'd
          req = nil
          
          # Response Code Error object cleared/init'd
          self.rce = nil
          
          # Response Code Error Number object cleared/init'd
          self.rce_code = nil
              
          # Temp Response Code Object reset/init'd
          temp_rce_code = nil
                
          # This section is for massing the URL related data together.
          url  = opts['RURL'] 
         
          # rparams
          rparams = opts['RPARAMS'] || []
                       
          # User Agent Information
          ua = opts['UA']
          agent.user_agent_alias = ua || 'Mechanize'  
          
=begin
This section requires cleanup. 

There's no need to statically set these.

-- John 9/29/12
=end

         #Begin setting a proxy if need be  
          if (proxyp != '') and (proxya != '') and (proxyp != nil) and (proxya !=nil)
          agent.set_proxy("#{proxya}", "#{proxyp}") 
          end 
                      
          # This is the HTTP Method chosen by the dev, set to lowercase
          req_type = opts['method'].downcase
            
          # Headers for the request
          headers = opts['HEADERS'] || {}
            
          # rfile = file to put on remote server 'PUT" method specific
          rfile = opts['RFILE'] || ''
            
          # rfile_content = content within the file
          rfile_content = opts['RFILECONTENT'] || ''     
           
           redirect_bool = opts['REDIRECT'] 
            
            if (is_false?(redirect_bool))
              agent.redirect_ok = false
            else
              agent.redirect_ok = true
            end
             
          # This allows us to set a CA file if need be
          ca_file = opts['CAFILE'] || nil
          if !ca_file == nil
              agent.ca_file = ca_file
          end
          
          # Keep Alive Settings
          keep_alive = opts['KEEP-ALIVE'] || nil
          if !keep_alive == nil
            agent.keep_alive = keep_alive              
          end
          
          #Timeout settings
          timeout = opts['TIMEOUT'] || nil
            if !timeout == nil
              agent.open_timeout = timeout
            end
          
          # Basic Authorization Settings
          basic_auth_user = opts['BASIC_AUTH_USER'] || nil
          basic_auth_pass = opts['BASIC_AUTH_PASS'] || nil     
          if (basic_auth_user) and (basic_auth_pass) 
            agent.basic_auth("#{basic_auth_user}", "#{basic_auth_pass}")
          end
          
            
          # Makes a decision based on the supplied HTTP Method.
          abbr = 'agent_'+ "#{req_type}"
			
          if self.respond_to?(abbr)
            self.send(abbr, agent, url, rparams, headers, rfile, rfile_content)
          end
          
          rescue Timeout::Error
            prnt_err("We've received a timeout to: #{rurl}")
          rescue Mechanize::ResponseCodeError => self.rce
            temp_rce_code = "#{self.rce}".match(/\d{3}/)
            self.rce_code = temp_rce_code[0].to_i   
          rescue => $!            
            prnt_err("Mechanize Error: #{$!}")
          
        
        end
    
        
    #
    # Check to see if the user or developer has set a redirect option to false
    #
    def is_false?(string)
     string == false
    end                
    
    #
    # Method to return a the request/resp debug info.
    # Most often used within modules to create dradis logs.
    #
    def req_seq
      file = "#{LogsDir}agent.log"
      str = ''
      if File.exists?(file)
       File.readlines(file).each do |line|
         str << "#{line}"
       end
      end     
      return str
    end
    
    #
    # HTTP GET
    #            
    def agent_get(agent, url, rparams, headers, rfile, rfile_content)
      # v1.0: agent.get({:url=>"#{url}", :headers => headers, :params => rparams})
	  agent.get(url, rparams, nil, headers)
    end    
    
                
    #
    # HTTP POST
    #
    def agent_post(agent, url, rparams, headers, rfile, rfile_content)
      # v1.0: agent.post("#{url}", rparams, headers)      
	  agent.post(url, rparams, headers)
		puts "AFTER POST"
    end  
     
     
    #
    # HTTP PUT
    #
    def agent_put(agent, url, rparams, headers, rfile, rfile_content)
      agent.put("#{url}#{rfile}", "#{rfile_content}", :headers => headers )
    end
    
    
    #
    # HTTP DELETE
    #
    def agent_delete(agent, url, rparams, headers, rfile, rfile_content)
      agent.delete(url, rparams, headers)
    end
    
    
    #
    # HTTP HEAD
    #
    def agent_head(agent, url, rparams, headers, rfile, rfile_content)
      agent.head(url, rparams, headers)
    end
    
    
    # Shim, makes conversion as painless as possible (we hope)
    
    alias send_request_cgi mech_req
    

end end end end
