library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controller is port (
  S: in STD_LOGIC_VECTOR (4 downto 0);
  --DISPLAY0, DISPLAY1, DISPLAY2, DISPLAY3: out integer range 0 to 9 ;
  Display: out STD_LOGIC_VECTOR (6 downto 0));
  alarm: out STD_LOGIC;
  clk: in std_logic;
  reset: in std_logic);
end controller;

architecture Behavioral of controller is

  component seven_segment
  Port (NUMBER: in STD_LOGIC_VECTOR (3 downto 0);
        HEX0: out STD_LOGIC_VECTOR (6 downto 0));
  end component;

  component two_number_split
  Port (NUMBER: in STD_LOGIC_VECTOR (6 downto 0);
        LEFT_DIGIT: out STD_LOGIC_VECTOR (3 downto 0);
        RIGHT_DIGIT: out STD_LOGIC_VECTOR (3 downto 0));
  end component;

  component clock_module
  Port (
          clk: in STD_LOGIC;
          output: out STD_LOGIC
      );
  end component;

  signal timer: std_logic_vector (13 downto 0);
  signal sectrigger : std_logic;
  signal min_left_out, min_right_out, hr_left_out, hr_right_out: std_logic_vector (3 downto 0);
  signal display_min_left_out, display_min_right_out, display_hr_left_out, display_hr_right_out: std_logic_vector (6 downto 0);
  signal DISPLAYHR, DISPLAYMIN: integer range 0 to 59;
  signal DISPLAYHR_vec, DISPLAYMIN_vec: std_logic_vector (6 downto 0);
  signal hours, whours: integer range 0 to 23;
  signal secs, mins, wmins: integer range 0 to 59;
  type state_type is (ntime, set_time, set_alarm);
  signal current_state: state_type;

  begin

    SECTIMER: process(clk,reset)   -- I feel this process is not required in my implementation
      variable timer_msb_to_zero : std_logic_vector(timer’RANGE);
    begin
      -- A code of a second-trigger will be placed here
      if reset=’1’ then
        timer <= (others => ’0’);
      elsif clk’EVENT and clk=’1’ then
        timer_msb_to_zero := timer;
        -- set msb to zero, the msb will be our overflow bit
        timer_msb_to_zero(timer’LENGTH-1) := ’0’;
        timer <= timer_msb_to_zero + 1;
      end if;
    end process SECTIMER;

    sectrigger <= timer(timer’LENGTH-1);

    FSM: process (clk,reset,current_state,secs,mins,hours,wmins,whours, S)
      variable next_state: state_type;
    begin
      -- Place your FSM-Code here
      if reset = ’1’ then
        hours <= 0; mins <= 0; secs <= 0;
        whours <= 0; wmins <= 0; alarm <= ’0’;
        current_state <= ntime;
      --elsif (clk’event and clk=’1’) then
      elsif (sectrigger = ’1’) then
        --if (not (current_state = set_time) and (sectrigger=’1’)) then
        if (not (current_state = set_time)) then
          -- Zhle Uhr hoch
          if secs = 59 then
            secs <= 0;
            if mins = 59 then
              mins <= 0;
              if hours = 23 then
                hours <= 0;
              else
                hours <= hours+1;
              end if;
            else
              mins <= mins+1;
            end if;
          else
            secs <= secs+1;
          end if;
        end if;
        case current_state is
          when ntime =>             -- check if alarm is set and set next state
              if S(4) = '1' then
                if hours = whours and mins = wmins then
                  alarm < = '1';
                end if;
              end if;
              DISPLAYHR <= hours;
              DISPLAYMIN <= mins;
              if S(0) = '1' and S(1) = '0' then
                  current_state <= set_time;
              else if S(0) = '0' and S(1) = '1' then
                  current_state <= set_alarm;
                else
                  current_state <= ntime;
                end if;
              end if;
          -- State Set_time, set minutes and hours with S(3) or S(4), set next state
          when set_time =>
              if S(0) = '1' and S(2) = '1' then
                if mins < 59 then
                  mins <= mins + 1;
                else mins < = 0;
              end if;
              if S(0) = '1' and S(3) = '1' then
                if hours < 23 then
                  mins <= mins + 1;
                else mins < = 0;
              end if;
              DISPLAYHR <= hours;
              DISPLAYMIN <= mins;
              if S(0) = '1' and S(1) = '0' then
                  current_state <= set_time;
              else if S(0) = '0' and S(1) = '1' then
                  current_state <= set_alarm;
                else
                  current_state <= ntime;
                end if;
              end if;
          -- state set_alarm, set WMinute and WStunde with S(3) bzw. S(4), set next state
          when set_alarm =>
              if S(1) = '1' and S(2) = '1' then
                if wmins < 59 then
                  wmins <= wmins + 1;
                else wmins < = 0;
              end if;
              if S(1) = '1' and S(3) = '1' then
                if whours < 23 then
                  wmins <= wmins + 1;
                else wmins < = 0;
              end if;
              DISPLAYHR <= whours;
              DISPLAYMIN <= wmins;
              if S(0) = '1' and S(1) = '0' then
                  current_state <= set_time;
              else if S(0) = '0' and S(1) = '1' then
                  current_state <= set_alarm;
                else
                  current_state <= ntime;
                end if;
              end if;
          when others =>
            DISPLAYHR <= hours;
            DISPLAYMIN <= mins;
            current_state <= ntime;
        end case;
      end if;
    end process FSM;

    DISPLAYHR_vec <= std_logic_vector(to_unsigned(DISPLAYHR, DISPLAYHR_vec'length));
    DISPLAYMIN_vec <= std_logic_vector(to_unsigned(DISPLAYMIN, DISPLAYMIN_vec'length));
    -- MINUTE-DISPLAY (TIME)
    MIN_CONVERT_STEP1: two_number_split port map(DISPLAYMIN_vec, min_left_out, min_right_out);
    MIN_CONVERT_STEP21: seven_segment port map(min_left_out, display_min_left_out);
    MIN_CONVERT_STEP22: seven_segment port map(min_right_out, display_min_right_out);
    -- HOURS-DISPLAY (TIME)
    HR_CONVERT_STEP1: two_number_split port map(DISPLAYHR_vec, hr_left_out, hr_right_out);
    HR_CONVERT_STEP21: seven_segment port map(hr_left_out, display_hr_left_out);
    HR_CONVERT_STEP22: seven_segment port map(hr_right_out, display_hr_right_out);


    -- Describes how to set the DISPLAY-Variables
    Switch_Display: process (S, DISPLAY10, DISPLAY11, DISPLAY20, DISPLAY21, DISPLAY30,
        DISPLAY31, DISPLAY40, DISPLAY41 ) is
        begin
          if current_state /= set_alarm then
            DISPLAY0 <= DISPLAY10 ;
            DISPLAY1 <= DISPLAY11;
            DISPLAY2 <= DISPLAY20 ;
            DISPLAY3 <= DISPLAY21 ;
          else
            DISPLAY0 <= DISPLAY30;
            DISPLAY1 <= DISPLAY31;
            DISPLAY2 <= DISPLAY40;
            DISPLAY3 <= DISPLAY41;
          end if;
    end process Switch_Display;

end Behavioral;
