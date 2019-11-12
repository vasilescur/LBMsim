transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/PLL.vo}
vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/shift_reg_v.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/lattice_boltzmann.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/DE1_SoC_Computer.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/hex_decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/VGA_Controller.v}
vlib PLL
vmap PLL PLL
vlog -vlog01compat -work PLL +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/PLL {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/PLL/PLL_0002.v}
vlib Computer_System
vmap Computer_System Computer_System
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/Computer_System.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_pio_zoom.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_pio_x_coord.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_pio_reset_screen.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_System_PLL.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_up_avalon_reset_from_locked_signal.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_System_PLL_sys_pll.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_ARM_A9_HPS.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_ARM_A9_HPS_hps_io.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_mem_if_hhp_qseq_synth_top.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0_acv_hard_addr_cmd_pads.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0_acv_hard_io_pads.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0_acv_hard_memphy.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0_acv_ldc.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0_altdqdqs.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0_clock_pair_generator.v}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0_generic_ddio.v}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_irq_mapper.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_burst_adapter_13_1.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_address_alignment.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_traffic_limiter.sv}
vlog -vlog01compat -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_router_002.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_mm_interconnect_0_router.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_axi_master_ni.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altdq_dqs2_acv_connect_to_hard_phy_cyclonev.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_mem_if_dll_cyclonev.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_mem_if_hard_memory_controller_top_cyclonev.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/altera_mem_if_oct_cyclonev.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_p0.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/hps_sdram_pll.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_ARM_A9_HPS_hps_io_border.sv}
vlog -sv -work Computer_System +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/Computer_System/synthesis/submodules/Computer_System_ARM_A9_HPS_fpga_interfaces.sv}

vlog -vlog01compat -work work +incdir+C:/Users/Jeff/Documents/Spring\ 2018/ECE\ 5760/DE1_SoC_Computer_LB {C:/Users/Jeff/Documents/Spring 2018/ECE 5760/DE1_SoC_Computer_LB/tb.v}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -L PLL -L Computer_System -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
