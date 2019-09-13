-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  USE STD.textio.all;
  USE WORK.classio.all;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT fax
          PORT(
                  fax_line : in std_logic;
						sys_clk : in std_logic;
						--p_ready : in std_logic;
						--motor_control: out std_logic;
						--print_data: out std_logic_vector(7 downto 0);
						--d_ready: out std_logic
				   );
          END COMPONENT;
			 
			 COMPONENT printer
			 PORT (  sys_clk: IN std_logic;
						--print_data: IN std_logic_vector(7 downto 0);
						--d_ready: IN std_logic;
						--p_ready: OUT std_logic;
						--motor_control: IN std_logic
					);
			 END COMPONENT;

          SIGNAL t_fax_line :  std_logic;
          SIGNAL t_sys_clk :  std_logic;
			 
          

  BEGIN

  -- Component Instantiation
          uut: fax PORT MAP(
                  t_fax_line,
                  t_sys_clk
          );

          uut1 : printer PORT MAP(
									t_sys_clk
								--	print_data => print_data,
								--	d_ready => d_ready,
								--	p_ready => p_ready,
								--	motor_control => motor_control
									);
  --  Test Bench Statements
			clk_process: process
			begin
				t_sys_clk <= '1','0' after 10 ns, '1' after 20 ns, '0' after 30 ns;
				wait for 40 ns;
			end process clk_process;
  
  
			 tb : PROCESS
			 
	  file infile : text is in "sample_input.txt";
	  file outfile  : text is out "output_result.txt";  
	  variable  buf: line;
	  variable check: std_logic;
          BEGIN
				
          wait for 100 ns; -- wait until global set/reset completes
			
			   wait until (t_sys_clk = '1' and t_sys_clk'event);

        -- Add user defined stimulus here
		while not(endfile (infile)) loop   
		read_v1d(infile, check);
		t_fax_line <= check;
		wait for 20 ns;
          -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
