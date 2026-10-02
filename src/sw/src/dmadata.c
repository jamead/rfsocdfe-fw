
// Trigger and Send DMA Data: ADC, TbT, FA

#include <stdio.h>

#include <xparameters.h>

#include <FreeRTOS.h>
#include <lwip/sys.h>
#include <lwip/stats.h>
#include "xil_cache.h"

#include "local.h"
#include "pl_regs.h"
#include "dmadata.h"

#include "xtime_l.h"

extern u32 soft_trig_cnt;



#define NUM_CHANNELS        4
#define SAMPLES_PER_CHUNK  12




void dma_arm() {

	//u32 *adc_ptr, *tbt_ptr, *fa_ptr;
	u32 adclen;


	//Disable the ADC,TbT,FA DMA logic (trig_logic.vhd)
	//xil_printf("   Disable DMA\r\n");
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_ADCENABLE_REG, 0);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TBTENABLE_REG, 0);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FAENABLE_REG, 0);


	//Read the DMA length registers, just so we can print them
	adclen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_ADCBURSTLEN_REG);
    adclen = 10000;

	xil_printf("Arming DMA...   DMA ADC Length = %d\r\n",adclen);


	//clear the DMA memory, not necessary, already Invalidated it.
	//adc_ptr = (u32 *) ADC_DMA_DATA;
	//for (i=0;i<10000000;i++)  adc_ptr[i] = 0;


	//reset the PL DMA FIFO
	Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FIFORST_REG, 1);
	Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FIFORST_REG, 0);

	//reset the AXI DMA Core
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_DMACR, 4);

	//Start the S2MM channel with all interrupts masked
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_DMACR, 0xF001);


	//Write the Destination Address for the ADC data
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_DA, ADC_DMA_DATA);



	//Write the S2MM transfer length (must be written last (PG021 p72)
    //length is in bytes, for adc: 4 adc channels * 2bytes/sample
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_LEN, (adclen+16) * 4 * 2);




	//Enable the ADC,TbT,FA DMA logic (trig_logic.vhd)
	//DMA triggers are disabled until rising edge of ADC_ENABLE_REG
	//xil_printf("   Enabling DMA Triggers\r\n");
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TBTENABLE_REG, 1);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FAENABLE_REG, 1);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_ADCENABLE_REG, 1);


}





/*******************************************************
  * DMA data format:
  *
*   12 samples from channel 0
*   12 samples from channel 1
*   12 samples from channel 2
*   12 samples from channel 3
*
* Then the pattern repeats.
*
* Each 32-bit word contains two 16-bit ADC samples:
*
*   bits 15:0   = first sample
*   bits 31:16  = second sample
********************************************************/

#define NSAMPLES_PER_CHANNEL 1000
#define NUM_CHANNELS        4
#define SAMPLES_PER_GROUP  12
#define WORDS_PER_GROUP    6

void process_ADC_dma(adcmsg_t *adcmsg, u32 nsamples)
{


    u32 i, j, k, regval, channel;
    s16 sample0, sample1;
    u32 *adc_data = (u32 *)ADC_DMA_DATA;

    static s16 adc_ch0[NSAMPLES_PER_CHANNEL];
    static s16 adc_ch1[NSAMPLES_PER_CHANNEL];
    static s16 adc_ch2[NSAMPLES_PER_CHANNEL];
    static s16 adc_ch3[NSAMPLES_PER_CHANNEL];


    nsamples = 200;
    xil_printf("DMA ADC Data...\r\n");


    int ch0_count = 0;
    int ch1_count = 0;
    int ch2_count = 0;
    int ch3_count = 0;


for (i = 0; i < nsamples; i++) {

    /*
     * Determine which ADC channel this group belongs to.
     *
     * i = 0  -> channel 0
     * i = 1  -> channel 1
     * i = 2  -> channel 2
     * i = 3  -> channel 3
     * i = 4  -> channel 0
     * etc.
     */
    channel = i % 4;


    /*
     * Each group has 12 samples.
     *
     * Since each 32-bit word contains two 16-bit samples,
     * read 6 words.
     */
    for (j = 0; j < WORDS_PER_GROUP; j++) {

        regval = *adc_data;
        adc_data++;


        /*
         * Extract the two ADC samples.
         *
         * Low 16 bits come first in time.
         */
        sample0 = (s16)(regval & 0xFFFF);

        sample1 = (s16)((regval >> 16) & 0xFFFF);


        /*
         * Store the samples in the correct channel array.
         */
        if (channel == 0) {

            adc_ch0[ch0_count] = sample0;
            ch0_count++;

            adc_ch0[ch0_count] = sample1;
            ch0_count++;
        }


        else if (channel == 1) {

            adc_ch1[ch1_count] = sample0;
            ch1_count++;

            adc_ch1[ch1_count] = sample1;
            ch1_count++;
        }


        else if (channel == 2) {

            adc_ch2[ch2_count] = sample0;
            ch2_count++;

            adc_ch2[ch2_count] = sample1;
            ch2_count++;
        }


        else if (channel == 3) {

            adc_ch3[ch3_count] = sample0;
            ch3_count++;

            adc_ch3[ch3_count] = sample1;
            ch3_count++;
        }
    }
}



xil_printf("\r\n");
xil_printf("Channel 0 - First 96 Samples\r\n");

for (k = 0; k < 96; k++) {

    xil_printf("%d   ", adc_ch0[k]);

    if (((k + 1) % 8) == 0) {
        xil_printf("\r\n");
    }
}


xil_printf("\r\n");
xil_printf("Channel 1 - First 96 Samples\r\n");

for (k = 0; k < 96; k++) {

    xil_printf("%d   ", adc_ch1[k]);

    if (((k + 1) % 8) == 0) {
        xil_printf("\r\n");
    }
}


xil_printf("\r\n");
xil_printf("Channel 2 - First 96 Samples\r\n");

for (k = 0; k < 96; k++) {

    xil_printf("%d   ", adc_ch2[k]);

    if (((k + 1) % 8) == 0) {
        xil_printf("\r\n");
    }
}


xil_printf("\r\n");
xil_printf("Channel 3 - First 96 Samples\r\n");

for (k = 0; k < 96; k++) {

    xil_printf("%d   ", adc_ch3[k]);

    if (((k + 1) % 8) == 0) {
        xil_printf("\r\n");
    }
}








    // Send buffer (size = nsamples * sizeof(adcmsg_t))
    //psc_send(the_server, 53, nsamples * sizeof(adcmsg_t), adcmsg);
}






static void dmadata_push(void *unused)
{
    (void)unused;

    static adcmsg_t adcmsg[ADC_DMA_MAX_LEN];

    u32 prev_soft_trig_cnt = 0;
    u32 adclen, tbtlen, falen;
    u32 trignum = 0, prevtrignum = 0;


    //dma_arm();
	//Read the DMA length registers
	//adclen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_ADCBURSTLEN_REG);
	//tbtlen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_TBTBURSTLEN_REG);
	//falen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_FABURSTLEN_REG);
    Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TESTDATAENB_REG, 0);

    while (1) {
        vTaskDelay(pdMS_TO_TICKS(10));

        //trignum is incremented after DMA data is pushed to DDR
        //trignum = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_TRIGCNT_REG);



        if (prev_soft_trig_cnt != soft_trig_cnt) {
            xil_printf("Received Soft Trigger Number: %d \r\n",soft_trig_cnt);
            prev_soft_trig_cnt = soft_trig_cnt;


            dma_arm();
            //Trigger the DMA
            Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_SOFTTRIG_REG, 1);
            Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_SOFTTRIG_REG, 0);

            //xil_printf("\nTrig Num: %d\r\n", trignum);
            //prevtrignum = trignum;
            vTaskDelay(pdMS_TO_TICKS(100));
            // Invalidate caches to see fresh DMA data
            Xil_DCacheInvalidateRange(ADC_DMA_DATA, ADC_DMA_MAX_LEN * sizeof(adcmsg_t));


            // get the DMA lengths
           	adclen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_ADCBURSTLEN_REG);


            // Process DMA data into adcmsg array
            process_ADC_dma(adcmsg, adclen);


            // Clear DMA Trigger Latch, allows for next trigger
            //Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TXTOIOC_DONE_REG, 1);
            //Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TXTOIOC_DONE_REG, 0);




            // Re-arm DMA for next trigger
            dma_arm();

        }
    }
}

void dmadata_setup(void)
{
    printf("INFO: Starting DMA Data daemon\n");
    sys_thread_new("dmadata", dmadata_push, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
}

