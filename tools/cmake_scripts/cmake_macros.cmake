macro(MCU_POST_BUILD TARGET_NAME)
   add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
      COMMENT "Creating ${TARGET_NAME}.hex file.."
      VERBATIM
      COMMAND ${CMAKE_OBJCOPY}
      ARGS -O ihex $<TARGET_FILE:${TARGET_NAME}> ${TARGET_NAME}.hex
   )

   add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
      COMMENT "Creating ${TARGET_NAME}.bin file.."
      COMMAND srec_cat
      ARGS ${TARGET_NAME}.hex -intel -crop 0x00000000 0x00080000 -o ${TARGET_NAME}.bin -binary
   )

    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
      COMMENT "Generate assembly listing..."
      VERBATIM
      COMMAND ${CMAKE_OBJDUMP}
      ARGS -S $<TARGET_FILE:${TARGET_NAME}> > ${TARGET_NAME}.lst
   )
   
   add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
      COMMENT "Dump information form ${TARGET_NAME}.elf file..."
      VERBATIM
      COMMAND ${CMAKE_READELF}
      ARGS -a $<TARGET_FILE:${TARGET_NAME}> > ${TARGET_NAME}_Symbols.txt
   )

   add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
      COMMENT "Checking ${TARGET_NAME}.elf size..."
      VERBATIM
      COMMAND echo -------------------------- SIZE --------------------------
      COMMAND ${CMAKE_OBJSIZE}
      ARGS $<TARGET_FILE:${TARGET_NAME}>
   )
endmacro()