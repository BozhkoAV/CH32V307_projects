#ifndef TM_FONTS_H
#define TM_FONTS_H 110

/* C++ detection */
#ifdef __cplusplus
extern C {
#endif

/**
 * @addtogroup TM_STM32F4xx_Libraries
 * @{
 */

/**
 * @defgroup TM_FONTS
 * @brief    Fonts library for all my LCD libraries
 * @{
 *
 * Default fonts library. It is used in all LCD based libraries.
 *
 * \par Supported fonts
 *
 * Currently, these fonts are supported:
 *  - 7 x 10 pixels
 *  - 11 x 18 pixels
 *  - 16 x 26 pixels
 *
 * \par Changelog
 *
@verbatim
 Version 1.0
  - First release
@endverbatim
 *
 * \par Dependencies
 *
@verbatim
 - STM32F4xx
 - STM32F4xx RCC
 - defines.h
@endverbatim
 */

#include "ch32v30x.h"

/**
 * @defgroup TM_LIB_Typedefs
 * @brief    Library Typedefs
 * @{
 */

/**
 * @brief  Font structure used on my LCD libraries
 */

typedef struct {
	uint8_t FontWidth;    /*!< Font width in pixels */
	uint8_t FontHeight;   /*!< Font height in pixels */
	const uint16_t *data; /*!< Pointer to data font data array */
} TM_FontDef_t;

/**
 * @}
 */

/**
 * @defgroup TM_FONTS_FontVariables
 * @brief    Library font variables
 * @{
 */

/**
 * @brief  7 x 10 pixels font size structure
 */

extern TM_FontDef_t TM_Font_7x10;

/**
 * @brief  11 x 18 pixels font size structure
 */

extern TM_FontDef_t TM_Font_11x18;

/**
 * @brief  16 x 26 pixels font size structure
 */

extern TM_FontDef_t TM_Font_16x26;

/* C++ detection */
#ifdef __cplusplus
}
#endif

#endif
