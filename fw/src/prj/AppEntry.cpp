#include "r_sci_spi.h"

extern spi_instance_t g_spi0;

void AppEntry(void)
{
    fsp_err_t res = R_SCI_SPI_Open(g_spi0.p_ctrl, g_spi0.p_cfg);
    while (1)
        ;
}