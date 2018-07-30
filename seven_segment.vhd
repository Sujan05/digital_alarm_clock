----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2018 01:47:13 PM
-- Design Name: 
-- Module Name: seven_segment - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_segment is
  Port (NUMBER: in STD_LOGIC_VECTOR (3 downto 0);
        HEX0: out STD_LOGIC_VECTOR (6 downto 0));
end seven_segment;

architecture Behavioral of seven_segment is
    SIGNAL digit_in : STD_LOGIC_VECTOR (6 downto 0);
begin
   process (NUMBER)
    begin
    case NUMBER is
        when "0000" => digit_in <= "1111110";
        when "0001" => digit_in <= "0110000";
        when "0010" => digit_in <= "1101101";
        when "0011" => digit_in <= "1111001";
        when "0100" => digit_in <= "0110011";
        when "0101" => digit_in <= "1011011";
        when "0110" => digit_in <= "1011111";
        when "0111" => digit_in <= "1110000";
        when "1000" => digit_in <= "1111111";
        when "1001" => digit_in <= "1111011";
        when OTHERS => digit_in <= "XXXXXXX";
    end case;
   end process;
   HEX0 <= not digit_in;
end Behavioral;
