
#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xil_cache.h"

#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "lwipopts.h"
#include "xil_printf.h"
#include "FreeRTOS.h"
#include "task.h"

/* Hardware support includes */
#include "pl_regs.h"
#include "psc_msg.h"
#include "rfdfe.h"

#include "math.h"








void set_fpleds(u32 msgVal)  {
	Xil_Out32(XPAR_M_AXI_BASEADDR + FP_LEDS_REG, msgVal);
}


void gen_sine_wave(int16_t *buffer, int num_points, double freq, double sample_rate) {

	const double AMPLITUDE = 32767.0;   // full-scale for int16_t
	double phase_inc = 2.0 * M_PI * freq / sample_rate;
    double phase = 0.0;

    for (int i = 0; i < num_points; i++) {
        double val = sin(phase);
        buffer[i] = (int16_t)(AMPLITUDE * val);
        phase += phase_inc;

        if (phase >= 2.0 * M_PI) {
            phase -= 2.0 * M_PI;
        }
    }
}





void write_dacawg() {

  int num_pts = 2000;  //max is 16k
  double freq = 19.987200e6;
  double sample_rate = 1.99872e9;
  int i;
  int16_t dac_buf[16000];


  gen_sine_wave(dac_buf,num_pts, freq, sample_rate);


  xil_printf("Writing DAC...\r\n");
  for (i=0;i<1600;i++) {
     // write the waveform
 	Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_ADDR_REG, i);
 	if (i < 1500)
   	  Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_DATA_REG, dac_buf[i]);
 	else
 	  Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_DATA_REG, 0);
 	if (i > 1400)
 		xil_printf("Address: %d  Data: %d\r\n", i, (int16_t)Xil_In32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_DATA_REG));
 	Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_WE_REG, 1);
 	Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_WE_REG, 0);
   }

   //write the number of samples to play back (each is 16 samples)
   Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_NUMSAMP_REG, 80);

   //trigger the ADC
   Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG, 1);
   //play it out the dac
   Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_TRIG_REG, 1);
   usleep(1);
   Xil_Out32(XPAR_M_AXI_BASEADDR + RFDAC_DPRAM_TRIG_REG, 0);
   sleep(1);


}







void soft_trig(u32 msgVal) {

	u32 wdcnt, active_trig;

    //Triggered from PV write to this register which sets it high
    active_trig = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG);
	if (msgVal == 1 && active_trig == 0) {
      xil_printf("Soft Trigger...\r\n");
      // clear the FIFO
      Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_RST_REG, 1);
      vTaskDelay(pdMS_TO_TICKS(10));
      Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_RST_REG, 0);
      wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
      xil_printf("FIFO Wdcnt after reset = %d\r\n",wdcnt);

      //Trigger
      Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG, 1);
      vTaskDelay(pdMS_TO_TICKS(10));

      //Trigger by writing to the DAC AWG, which will trigger the ADC
      //write_dacawg();



      wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
      xil_printf("FIFO Wdcnt after trigger = %d\r\n",wdcnt);
      //Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG, 0);
      wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
      xil_printf("FIFO Wdcnt = %d\r\n",wdcnt);
	}
}

void set_eventno(u32 msgVal) {
	Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_DMA_TRIGNUM_REG, msgVal);
}

void set_trigsrc(u32 msgVal) {
    if (msgVal == 0) {
        xil_printf("Setting Trigger Source to EVR\r\n");
        Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TRIGSRC_REG, msgVal);
    }
    else if (msgVal == 1) {
	    xil_printf("Setting Trigger Source to INT (soft)\r\n");
        Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TRIGSRC_REG, msgVal);
    }
    else
        xil_printf("Invalid Trigger Source\r\n");

}













void reg_settings(void *msg) {

	u32 *msgptr = (u32 *)msg;
	u32 addr;

	typedef union {
	    u32 u;
	    float f;
	    s32 i;
	} MsgUnion;

	MsgUnion data;


    addr = htonl(msgptr[0]);
    data.u = htonl(msgptr[1]);

    //xil_printf("Addr: %d    Data: %d\r\n",addr,data.u);


    switch(addr) {
        case SOFT_TRIG_MSG:
            soft_trig(data.u);
            break;

        case EVENT_NO_MSG:
           	xil_printf("DMA Event Number Message:   Value=%d\r\n",data.u);
            set_eventno(data.u);
            break;

        case FP_LED_MSG:
          	xil_printf("Setting FP LED:   Value=%d\r\n",data.u);
          	//set_fpleds(data.u);
          	break;



        default:
          	xil_printf("Msg not supported yet...\r\n");
           	break;
        }

}



