#
#   Copyright 2011 Wade Alcorn wade@bindshell.net
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
module BeEF
module Extension
module Metasploit
  
  extend BeEF::API::Extension

  # Translates msf exploit options to beef options array
  def self.translate_options(msf_options)
    options = []
    msf_options.each{|k,v|
        case v['type']
            when "string", "address", "port", "integer"
                v['type'] = 'text'
            when "bool"
                v['type'] = 'checkbox'
            when "enum"
                v['type'] = 'combobox'
                v['store_type'] = 'arraystore',
                v['store_fields'] = ['enum'],
                v['store_data'] = self.translate_enums(v['enums']),
                v['valueField'] = 'enum',
                v['displayField'] = 'enum',
                v['autoWidth'] = true,
                v['mode'] = 'local'
        end
        v['name'] = k
        v['label'] = k
        options << v
    }
    return options
  end

  # Translates msf payloads to a beef compatible drop down
  def self.translate_payload(payloads)
    if payloads.has_key?('payloads')
       values = self.translate_enums(payloads['payloads'])
       if values.length > 0
           return { 
                'name' => 'payload', 
                'type' => 'combobox', 
                'ui_label' => 'Payload', 
                'store_type' => 'arraystore',
                'store_fields' => ['payload'], 
                'store_data' => values,
                'valueField' => 'payload', 
                'displayField' => 'payload', 
                'mode' => 'local', 
                'autoWidth' => true
          }
      end
    end
    return nil
  end

  # Translates metasploit enums to ExtJS combobox store_data
  def self.translate_enums(enums)
       values = []
       enums.each{|e|
            values << [e]
       }
       return values
  end
  
  
end
end
end

require 'extensions/metasploit/rpcclient'
require 'extensions/metasploit/api'
