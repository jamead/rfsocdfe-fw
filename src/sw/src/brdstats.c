
// remote reporting of select LwIP statistics

#include <stdio.h>


#include <xparameters.h>
//#include "xadcps.h"

#include <FreeRTOS.h>
#include <lwip/sys.h>
#include <lwip/stats.h>

#include "local.h"
#include "pl_regs.h"

#include "xsysmonpsu.h"


#include "xtime_l.h"
#include "rfdfe.h"

#define MAX_TASKS 16

//static XSysMon xmon;

extern XSysMonPsu SysMonInstance;



float sysmon_read_stats() {

	s32 temprawdata;
	float val;

    // Read the temperature data
    temprawdata = XSysMonPsu_GetAdcData(&SysMonInstance, XSM_CH_TEMP, XSYSMON_PS);

    // Convert raw temperature data to degrees Celsius
    val = XSysMonPsu_RawToTemperature_OnChip(temprawdata);
    //printf("Die Temp in func: %f\n",val);
    return(val);

}



static void brdstats_push(void *unused)
{
    (void)unused;
    u32 i;
    float sfpregs[5];

    static struct {
        uint32_t githash;  // 0
        struct {
            uint32_t brd[4]; // 4,8,12,16
            uint32_t reg[4]; //20,24,28,32
            uint32_t die_ps; // 36
            uint32_t die_pl; // 40
            uint32_t rsvd[4]; // 44,48,52,56
        } temps;
        struct {
        	uint32_t vin_v;   //60
        	uint32_t vin_i;   //64
            uint32_t v3_3_v; // 68
            uint32_t v3_3_i; // 72
            uint32_t v2_5_v; // 76
            uint32_t v2_5_i; // 80
            uint32_t v1_8_v; // 84
            uint32_t v1_8_i; // 88
            uint32_t v1_2ddr_v; // 92
            uint32_t v1_2ddr_i; // 96
            uint32_t v0_85_v; // 100
            uint32_t v0_85_i; // 104
            uint32_t v2_5mgt_v; // 108
            uint32_t v2_5mgt_i; // 112
            uint32_t v1_2mgt_v; // 116
            uint32_t v1_2mgt_i; // 120
            uint32_t v0_9mgt_v; // 124
            uint32_t v0_9mgt_i; // 128
            uint32_t vadc_avcc_v; //132
            uint32_t vadc_avcc_i; //136
            uint32_t vadc_avcc_aux_v; //140
            uint32_t vadc_avcc_aux_i; //144
            uint32_t vdac_avcc_v; //148
            uint32_t vdac_avcc_i; //152
            uint32_t vdac_avcc_aux_v; //156
            uint32_t vdac_avcc_aux_i; //160
            uint32_t vdac_avtt_v; //164
            uint32_t vdac_avtt_i; //168
        } pwr;
        struct {
        	uint32_t temp[6];   //140,144,148,152,156,160
        	uint32_t vcc[6];    //164,168,172,176,180,184
        	uint32_t txbias[6]; //188,192,196,200,204,208
        	uint32_t txpwr[6];  //212,216,220,224,228,232
        	uint32_t rxpwr[6];  //236,240,244,248,252,256
        }sfp;
        // for backwards compatibility, must only append new values.
    } msg;




    while(1) {

        vTaskDelay(pdMS_TO_TICKS(1000));


        //read FPGA version (git checksum) from PL register
        msg.githash = Xil_In32(XPAR_M_AXI_BASEADDR + GIT_SHASUM);

        //read DFE temperature from i2c bus
        i2c_set_port_expander(I2C_PORTEXP1_ADDR,1);

        msg.temps.brd[0] = htonf(read_i2c_temp(BRDTEMP0_ADDR));
        msg.temps.brd[1] = htonf(read_i2c_temp(BRDTEMP1_ADDR));
        msg.temps.brd[2] = htonf(read_i2c_temp(BRDTEMP2_ADDR));
        msg.temps.brd[3] = htonf(read_i2c_temp(BRDTEMP3_ADDR));

        //read die temps
    	//printf("FPGA Temp: %f\r\n",sysmon_read_stats());
        msg.temps.die_ps = htonf(sysmon_read_stats());
        //msg.brd_temps.die_ps = htonf(sysmon_ps_getTemp());

        //read temps from LTC2991 chips
    	i2c_set_port_expander(I2C_PORTEXP1_ADDR,4);
    	i2c_configure_ltc2991();

        msg.temps.reg[0] = htonf(i2c_ltc2991_reg1_temp());
        msg.temps.reg[1] = htonf(i2c_ltc2991_reg2_temp());
        msg.temps.reg[2] = htonf(i2c_ltc2991_reg3_temp());
        msg.temps.reg[3] = htonf(i2c_ltc2991_reg4_temp());


        //read voltage & currents from LTC2991 chips
        msg.pwr.vin_v = htonf(i2c_ltc2991_vcc_vin());
        msg.pwr.vin_i = htonf(i2c_ltc2991_vcc_vin_current());
        msg.pwr.v3_3_v = htonf(i2c_ltc2991_vcc_3v3());
        msg.pwr.v3_3_i = htonf(i2c_ltc2991_vcc_3v3_current());
        msg.pwr.v2_5_v = htonf(i2c_ltc2991_vcc_2v5());
        msg.pwr.v2_5_i = htonf(i2c_ltc2991_vcc_2v5_current());
        msg.pwr.v1_8_v = htonf(i2c_ltc2991_vcc_1v8());
        msg.pwr.v1_8_i = htonf(i2c_ltc2991_vcc_1v8_current());
        msg.pwr.v1_2ddr_v = htonf(i2c_ltc2991_vcc_1v2_ddr());
        msg.pwr.v1_2ddr_i = htonf(i2c_ltc2991_vcc_1v2_ddr_current());
        msg.pwr.v0_85_v = htonf(i2c_ltc2991_vcc_0v85());
        msg.pwr.v0_85_i = htonf(i2c_ltc2991_vcc_0v85_current());
        msg.pwr.v2_5mgt_v = htonf(i2c_ltc2991_vcc_mgt_2v5());
        msg.pwr.v2_5mgt_i = htonf(i2c_ltc2991_vcc_mgt_2v5_current());
        msg.pwr.v1_2mgt_v = htonf(i2c_ltc2991_vcc_mgt_1v2());
        msg.pwr.v1_2mgt_i = htonf(i2c_ltc2991_vcc_mgt_1v2_current());
        msg.pwr.v0_9mgt_v = htonf(i2c_ltc2991_vcc_mgt_0v9());
        msg.pwr.v0_9mgt_i =  htonf(i2c_ltc2991_vcc_mgt_0v9_current());

        msg.pwr.vadc_avcc_v =  htonf(i2c_ltc2991_vadc_avcc());
        msg.pwr.vadc_avcc_i =  htonf(i2c_ltc2991_vadc_avcc_current());
        msg.pwr.vadc_avcc_aux_v =  htonf(i2c_ltc2991_vadc_avcc_aux());
        msg.pwr.vadc_avcc_aux_i =  htonf(i2c_ltc2991_vadc_avcc_aux_current());

        msg.pwr.vdac_avcc_v =  htonf(i2c_ltc2991_vdac_avcc());
        msg.pwr.vdac_avcc_i =  htonf(i2c_ltc2991_vdac_avcc_current());
        msg.pwr.vdac_avcc_aux_v =  htonf(i2c_ltc2991_vdac_avcc_aux());
        msg.pwr.vdac_avcc_aux_i =  htonf(i2c_ltc2991_vdac_avcc_aux_current());

        msg.pwr.vdac_avtt_v =  htonf(i2c_ltc2991_vdac_avtt());
        msg.pwr.vdac_avtt_i =  htonf(i2c_ltc2991_vdac_avtt_current());

        /*
        // read SFP status information from i2c bus
        for (i=0;i<=5;i++) {
           i2c_sfp_get_stats(&sfpregs, i);
           msg.sfp.temp[i] = htonf(sfpregs[0]);
           msg.sfp.vcc[i] = htonf(sfpregs[1]);
           msg.sfp.txbias[i] = htonf(sfpregs[2]);
           msg.sfp.txpwr[i] = htonf(sfpregs[3]);
           msg.sfp.rxpwr[i] = htonf(sfpregs[4]);
        }
        */

        /*
        // Read power management info from i2c bus
    	i2c_set_port_expander(I2C_PORTEXP1_ADDR,8);
        msg.reg_temps.pwrmgmt = htonf(i2c_ltc2977_stats());
        */

        psc_send(the_server, 102, sizeof(msg), &msg);
    }
}

void brdstats_setup(void)
{
    printf("INFO: Starting board stats daemon\n");
    sys_thread_new("brdstats", brdstats_push, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
}

