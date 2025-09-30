#include "hal_data.h"

#define CS_ASSERT(x)	 R_IOPORT_PinWrite(&g_ioport_ctrl, x, BSP_IO_LEVEL_HIGH);
#define CS_DE_ASSERT(x)	 R_IOPORT_PinWrite(&g_ioport_ctrl, x, BSP_IO_LEVEL_LOW);

static uint8_t const data[] = {0xAA, 0x55, 0x8C, 0xBB};

void sci_spi_callback(spi_callback_args_t *p_args)
{

}

void hal_entry(void)
{
    uint8_t res = R_SCI_SPI_Open(g_spi.p_ctrl, g_spi.p_cfg);

    while (1)
    {
    	CS_DE_ASSERT(SPI_CS);

        res = R_SCI_SPI_Write(g_spi.p_ctrl,
                              data,
                              sizeof(data),
                              SPI_BIT_WIDTH_8_BITS);
        CS_ASSERT(SPI_CS);
    }

#if BSP_TZ_SECURE_BUILD
    /* Enter non-secure code */
    R_BSP_NonSecureEnter();
#endif
}

#if BSP_TZ_SECURE_BUILD

FSP_CPP_HEADER
BSP_CMSE_NONSECURE_ENTRY void template_nonsecure_callable();

/* Trustzone Secure Projects require at least one nonsecure callable function in order to build (Remove this if it is not required to build). */
BSP_CMSE_NONSECURE_ENTRY void template_nonsecure_callable()
{
}
FSP_CPP_FOOTER

#endif
