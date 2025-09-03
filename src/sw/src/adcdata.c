
// Trigger and Send DMA Data: ADC, TbT, FA

#include <stdio.h>

#include <xparameters.h>

#include <FreeRTOS.h>
#include <lwip/sys.h>
#include <lwip/stats.h>
#include "xil_cache.h"

#include "local.h"
#include "rfdfe.h"
#include "pl_regs.h"


#include "xtime_l.h"




void processADC(s16 *adcmsg, u32 nsamples, u32 fifoaddr)
{
    u32 i, j, data;
    s16 *adcmsgbase = adcmsg;

    // Each FIFO word is 32 bits: two 16-bit ADC samples
    // FIFO is 256 bits: 12–16 bit ADC samples, 4 words of zeros
    for (i = 0; i<nsamples; i=i+12) {
        for (j = 0; j<8; j++) {
            data = Xil_In32(XPAR_M_AXI_BASEADDR + fifoaddr);

            if (j < 6) {
                // Extract upper 16 bits and lower 16 bits
                s16 sample_high = (s16)((data >> 16) & 0xFFFF);
                s16 sample_low  = (s16)(data & 0xFFFF);

                // Scale samples (right shift by 2)
                sample_high >>= 2;
                sample_low  >>= 2;
                //printf("i=%d: j=%d    %d   %d\n",i,j,sample_high,sample_low);

                // Store in network byte order
                *adcmsg++ = htons(sample_high);
                *adcmsg++ = htons(sample_low);
            }
            // j >= 6: just read FIFO to skip zero words
        }
    }


    // Debug print first 50 samples, 12 per line
    for (i = 0; i < 12*4; i++) {
        s16 sample = (s16) ntohs(adcmsgbase[i]);
        // Print sample with a space
        printf("%6d ", sample);
        // After every 12 samples, print a newline
        if ((i + 1) % 12 == 0)
            printf("\n");
    }
    printf("\n");

}



/*
void processADC(s16 *adcmsg, u32 nsamples, u32 fifoaddr)
{

	u32 i, j, data, wdcnt;
    s16 *adcmsgbase = adcmsg;

    //Read out of ADC data is packed in a FIFO which is 256bits.
    //12-16bit ADC samples, 4-16bit zeros.
    //FIFO is read out 32 bits at a time.
    for (i=0;i<nsamples;i=i+12) {
	    for (j=0;j<8;j++) {
	        if (j<6) {
	            data = Xil_In32(XPAR_M_AXI_BASEADDR + fifoaddr);
	            *adcmsg++ = htons(((s16) ((data & 0xFFFF0000) >> 16)) >> 2);
	            //xil_printf("%d\r\n",adcval>>2);
	            *adcmsg++ = htons((s16) ((data & 0xFFFF) >> 2));
                //xil_printf("%d\r\n",adcval>>2);
	        }
            else
   	            data = Xil_In32(XPAR_M_AXI_BASEADDR + fifoaddr);
        }
    }

   wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + fifoaddr+4);
   xil_printf("FIFO Wdcnt = %d\r\n",wdcnt);



    // Debug print first 10
    for (i = 0; i < 100; i++)
        xil_printf("%d\r\n", ntohs(adcmsgbase[i]));



}

*/




static void adcdata_push(void *unused)
{
    (void)unused;

     u32 triggered, wdcnt;

     #define ADC_MAX_LEN 8000*12

     static s16 adc[ADC_MAX_LEN];
     //static s16 chb[ADC_MAX_LEN];
     //static s16 chc[ADC_MAX_LEN];
     //static s16 chd[ADC_MAX_LEN];



    while (1) {
        vTaskDelay(pdMS_TO_TICKS(10));

        //Triggered from PV write to this register which sets it high
        triggered = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG);

        if (triggered == 1) {
            vTaskDelay(pdMS_TO_TICKS(100));
            xil_printf("Received ADC Trigger...\r\n");

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC2_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 62, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC3_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 63, sizeof(adc), adc);


            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC0_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 60, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC1_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 61, sizeof(adc), adc);



            //Clear the trigger register, to allow another trigger
            Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG, 0);

            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch0 Wdcnt after reading FIFO = %d\r\n",wdcnt);
            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC1_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch1 Wdcnt after reading FIFO = %d\r\n",wdcnt);
            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC2_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch2 Wdcnt after reading FIFO = %d\r\n",wdcnt);
            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC3_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch3 Wdcnt after reading FIFO = %d\r\n",wdcnt);


        }
    }
}

void adcdata_setup(void)
{
    printf("INFO: Starting ADC Data daemon\n");
    sys_thread_new("adcdata", adcdata_push, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
}

