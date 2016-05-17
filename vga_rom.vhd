library ieee;
use ieee.std_logic_1164.all;

entity vga_rom is
port(
	clk_0,reset: in std_logic;
	hs,vs: out STD_LOGIC; 
	r,g,b: out STD_LOGIC_vector(2 downto 0);
   ps2_clk1 : inout std_logic;
   ps2_data1 : inout std_logic;
	left_button1 : out std_logic;
   mousex1: buffer std_logic_vector(9 downto 0);
   mousey1: buffer std_logic_vector(9 downto 0);
   error_no_ack1 : out std_logic 
);
end vga_rom;

architecture vga_rom of vga_rom is

component vga640480 is
	 port(
			address		:		  out	STD_LOGIC_VECTOR(13 DOWNTO 0);
			reset       :         in  STD_LOGIC;
			clk25       :		  out std_logic; 
			q		    :		  in STD_LOGIC_vector(0 downto 0);
			clk_0       :         in  STD_LOGIC; --100Mʱ������
			hs,vs       :         out STD_LOGIC; --��ͬ������ͬ���ź�
			r,g,b       :         out STD_LOGIC_vector(2 downto 0)
	  );
end component;

component ps2_mouse is
  port( clk_in : in std_logic;
        reset_in : in std_logic;
        ps2_clk : inout std_logic;
        ps2_data : inout std_logic;
        left_button : out std_logic;
        mousex: buffer std_logic_vector(9 downto 0);
        mousey: buffer std_logic_vector(9 downto 0);
        error_no_ack : out std_logic );       
end component;

component digital_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

signal address_tmp: std_logic_vector(13 downto 0);
signal clk25: std_logic;
signal q_tmp: std_logic_vector(0 downto 0);


begin

u1: vga640480 port map(
						address=>address_tmp, 
						reset=>reset, 
						clk25=>clk25, 
						q=>q_tmp, 
						clk_0=>clk_0, 
						hs=>hs, vs=>vs, 
						r=>r, g=>g, b=>b
					);
u2: digital_rom port map(	
						address=>address_tmp, 
						clock=>clk25, 
						q=>q_tmp
					);
u3: ps2_mouse port map( 
		  clk_in=> clk_0,
        reset_in=> reset,
        ps2_clk=>ps2_clk1,
        ps2_data=>ps2_data1,
        left_button=>left_button1,
        mousex=>mousex1,
        mousey=>mousey1,
        error_no_ack=>error_no_ack1
		  );       
end vga_rom;