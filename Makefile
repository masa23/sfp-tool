install:
	install -d /opt/sfp-tool/
	install -d /opt/sfp-tool/ruby-libsfp/lib/sfp/
	install -m 0644 ruby-libsfp/lib/sfp/eeprom.rb /opt/sfp-tool/ruby-libsfp/lib/sfp/eeprom.rb
	install -m 0644 ruby-libsfp/lib/sfp/rw.rb /opt/sfp-tool/ruby-libsfp/lib/sfp/rw.rb
	install -m 0644 sfp-tool.py /opt/sfp-tool/sfp-tool.py 
	install -m 0644 rewrite.rb /opt/sfp-tool/rewrite.rb
	install -m 0644 sfp-tool.service /etc/systemd/system/sfp-tool.service
	systemctl daemon-reload
	systemctl restart sfp-tool
