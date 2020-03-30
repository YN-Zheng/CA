//Forwarding Unit
//Function: Solve data hazard, make decision on forwarding which result(alu_MEM or data_to_reg_WB) to which register (Rt or Rs or both)(EX)


/*****************************
	test WB first. if WB and MEM happens at the same time, MEM will overwrite WB (see NOTICE 1)
if(reg_write_WB == 1) // WB	//regfile_wdata_WB
{
	if(rs_EX == regfile_waddr_WB)
		forwarding_rs = 1;
	if(rt_EX == regfile_waddr_WB)
		forwarding_rt = 1;
}

if(reg_write_MEM == 1)   // MEM //alu_out_MEM
{
	if(mem_2_reg_MEM == 0)   // AI
	{
		if(rs_EX == regfile_waddr_MEM)
			forwarding_rs = 2;
		if(rt_EX == regfile_waddr_MEM)
			forwarding_rt = 2;
	}
	else				// LW
	{
		//stall the pipline
	}	
}
********************************************/
//NOTICE 1 
	//principle of proximity: if MEM and WB both need forwarding. choose the MEM(alu_MEM)
	// example:
	// L1 add s1,s2,s3; (s1 in WB)
	// L2 add s1,s1,s3; (s1 in MEM)
	// L3 add s4,s1,s3;   // here we can find that s1 is both dependent on L1(WB) and L2(MEM). Clearly we should choose MEM.
//NOTICE 2
	// when dealing with:
	// arithmetical instruction(ADD,MUL...)------in WB or MEM------	forwarding directly------------
	// LW----------------------------------------in WB ------------	forwarding directly------------
	// LW----------------------------------------in MEM -----------	need stall the pipeline--------
	// use reg_write and mem_2_reg_MEM to tell LW or AI
	//--------------| reg_write | mem_2_reg |
	//     AI    	|  	1		|	0		|
	//     LW		|	1		|	1		|
	
/*************************************structure***************************/

//Inputs:
	//clk: System clock
	//rs_EX: instruction_EX[25-21], address of rs
	//rt_EX: instruction_EX[20-16], address of rt

	
	//regfile_waddr_WB: 	address of reg that need to be write in WB
	//regfile_waddr_MEM:	... in MEM
	
	//reg_write_MEM
	//reg_write_WB
	//mem_2_reg_MEM
	//mem_2_reg_WB
	
//Outputs:
	//forwarding_rs: flag for mux_register_rs. 
		// 0: choose original 
		// 1: choose data_to_reg_WB
		// 2: choose alu_MEM
	//forwarding_rt: flag for mux_register_rt. 
		// 0: choose original 
		// 1: choose data_to_reg_WB
		// 2: choose alu_MEM
	
	//pipline_en[3:0]: 	if stall-----1000 (IF/ID/MEM = 0, WB = 1)
					//	else-----1111


// rs_EX :updated_pc_EX[25-21]
// rt_EX :updated_pc_EX[20-16]

// RD_MEM: regfile_waddr_MEM
// RD_wb: regfile_waddr_WB

/******************************start working*********************************/
module sram#() (
	input wire		      clk,
	input wire		[4:0] rs_EX,
	input wire		[4:0] rt_EX,
	input wire		[4:0] regfile_waddr_WB,
	input wire		[4:0] regfile_waddr_MEM,
	input wire			reg_write_MEM,
	input wire 			reg_write_WB,
	input wire			mem_2_reg_MEM,
	input wire 			mem_2_reg_WB,


	output reg	[3:0] pipline_en,
	output reg	[1:0] forwarding_rs,
	output reg	[1:0] forwarding_rt
);

   parameter integer ORIGIN			= 2'b0;
   parameter integer FROM_WB		= 2'b1;
   parameter integer FROM_MEM		= 2'b2;



	
endmodule


