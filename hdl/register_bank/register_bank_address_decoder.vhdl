--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_address_decoder.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-12
-- Last update : 2018-05-23
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Template for the address decoder of the AXI-4 register bank
--               generator. Generates the according write enables for the
--               different registers.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-23  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library reg_bank;
use reg_bank.register_bank_config.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_address_decoder  is
  port (
    clock_i             : in  std_logic;
    reset_n_i           : in  std_logic;

    decode_error_o      : out std_logic;                                         --! Status signal that indicates that a non-existing address should be accessed

    write_en_i          : in  std_logic;                                         --! Global write enable signal
    address_i           : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);        --! Address of the register
    bus_data_i          : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);       --! Data coming from the bus

    register_write_en_o : out register_write_en_t;                               --! Record with an enable signal for each register
    register_data_o     : out std_logic_vector(REGISTER_WIDTH-1 downto 0)        --! Output data to the registers
  );
end entity register_bank_address_decoder;

--------------------------------------------------------------------------------
--! @brief RTL description of the register bank write controller.
--------------------------------------------------------------------------------
architecture rtl of register_bank_address_decoder is

  signal address_int  : integer;                                                 --! Integer representation of the register address
  signal decode_error : std_logic;

begin

  address_int <= to_integer(unsigned(address_i));

  write_select : process(clock_i)
  begin
    if rising_edge(clock_i) then
      -- Put '0' on all outputs per default
      register_write_en_o <= (others => '0');

      if (write_en_i = '1') then
        decode_error_o <= '0';
        case address_int is

          when 16#0# =>
            register_write_en_o.master_reset         <= '1';
          when 16#1# =>
            register_write_en_o.rxpath_reset         <= '1';
          when 16#2# =>
            register_write_en_o.txpath_reset         <= '1';


          when others =>
            decode_error_o <= '1';
        end case;
      end if;
    end if;

    -- Forward bus data to the registers
    register_data_o <= bus_data_i;

  end process write_select;

end architecture rtl;
