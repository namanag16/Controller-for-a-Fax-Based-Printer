-- the process polls a input pin d_ready. if a valid record is available to be sent d_ready will be '1' and it will
-- continue to be one until the whole record is not processed.. when the whole record is processed the "i_sent_it" signal 
-- will be set by the process after which d_ready can be reset

-- the process reads data from an array of 528 bits which is the maximum record length and sends it out serially 
-- when there is no record to be sent .. d_ready is 0 and the process will output 1 

send_data: process(synch_clk) 
count : integer :=0;
begin 
 if(synch_clk '1' and synch_clk'event) then
	if(d_ready ='1') then 
		out_bit <= arr(527);
		count := count+1;
		if(count<528) then
			arr := arr(526 downto 0) & '1';
		else
			i_sent_it<='1';
			count:=0;
		end if;
	else
		out_bit<='1';
	end if;
 end if;

end process;