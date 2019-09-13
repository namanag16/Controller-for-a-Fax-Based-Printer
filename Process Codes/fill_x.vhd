-- getting inputs from port d_in(8 bit_vector) 
-- x is an array of 64 in length .. 8 bits each
-- the process runs only if a signal is set such that "give next row" .. reply comes as "sending next row" .. 
-- the process sends "ack" .. and starts getting data from next clock cycle 
-- the process stops after receiving 64 bytes of data
fill_x process(sys_clk)
signal ack : bit :=0;
variable count : integer :=0;
begin
	if(sys_clk = '1' and sys_clk'event) then
		if(sending_next_row = '1') then
			ack<='1';
		end if;
	end if;
	if(ack='1') then
		x(count):= d_in;
		count := count + 1;
		if(count = 65) then
			ack<=0;
		end if;
	end if;
end process fill_x;
