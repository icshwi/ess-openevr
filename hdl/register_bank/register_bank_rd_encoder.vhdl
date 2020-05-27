--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_rd_encoder.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-12
-- Last update : 2018-05-21
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description :
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-21  Christian Amstutz
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
entity register_bank_rd_encoder  is
  port (
    clock_i           : in  std_logic;                                    --! The output data is registered according to this clock
    reset_n_i         : in  std_logic;                                    --! Asynchronous low-active reset

    decode_error_o    : out std_logic;                                    --! Read access to address which does not allow read
    read_en_i         : in  std_logic;                                    --! Read enable
    address_i         : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);   --! Register address

    register_data_i   : in  register_bus_read_t;                          --! Record of values stored in the registers

    bus_data_o        : out std_logic_vector(REGISTER_WIDTH-1 downto 0)   --! Value of selected register (registered)
  );
end entity register_bank_rd_encoder;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_rd_encoder is
  signal address_int : integer;                                           --! Integer representation of the register address
begin

  address_int <= to_integer(unsigned(address_i));

  output_select : process (clock_i)
  begin
    if rising_edge(clock_i) then
      if (reset_n_i = '0') then
        decode_error_o <= '0';
        bus_data_o <= (others => '0');
      else
        if (read_en_i = '1') then
          decode_error_o <= '0';
          case address_int is

            when 16#0# =>
              bus_data_o <= register_data_i.master_reset;
            when 16#1# =>
              bus_data_o <= register_data_i.rxpath_reset;
            when 16#2# =>
              bus_data_o <= register_data_i.txpath_reset;


            when others =>
              decode_error_o <= '1';
          end case;
        end if;
      end if;
    end if;
  end process output_select;

end architecture rtl;
