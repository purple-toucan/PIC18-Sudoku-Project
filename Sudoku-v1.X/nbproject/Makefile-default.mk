#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Sudoku-v1.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Sudoku-v1.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=GLCD.asm KeyPad.asm Main.asm Write_Cells.asm config.asm Draw_Grid.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/GLCD.o ${OBJECTDIR}/KeyPad.o ${OBJECTDIR}/Main.o ${OBJECTDIR}/Write_Cells.o ${OBJECTDIR}/config.o ${OBJECTDIR}/Draw_Grid.o
POSSIBLE_DEPFILES=${OBJECTDIR}/GLCD.o.d ${OBJECTDIR}/KeyPad.o.d ${OBJECTDIR}/Main.o.d ${OBJECTDIR}/Write_Cells.o.d ${OBJECTDIR}/config.o.d ${OBJECTDIR}/Draw_Grid.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/GLCD.o ${OBJECTDIR}/KeyPad.o ${OBJECTDIR}/Main.o ${OBJECTDIR}/Write_Cells.o ${OBJECTDIR}/config.o ${OBJECTDIR}/Draw_Grid.o

# Source Files
SOURCEFILES=GLCD.asm KeyPad.asm Main.asm Write_Cells.asm config.asm Draw_Grid.asm


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/Sudoku-v1.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=18f87k22
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/GLCD.o: GLCD.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/GLCD.o.d 
	@${RM} ${OBJECTDIR}/GLCD.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/GLCD.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/GLCD.lst\" -e\"${OBJECTDIR}/GLCD.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/GLCD.o\" \"GLCD.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/GLCD.o"
	@${FIXDEPS} "${OBJECTDIR}/GLCD.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/KeyPad.o: KeyPad.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/KeyPad.o.d 
	@${RM} ${OBJECTDIR}/KeyPad.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/KeyPad.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/KeyPad.lst\" -e\"${OBJECTDIR}/KeyPad.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/KeyPad.o\" \"KeyPad.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/KeyPad.o"
	@${FIXDEPS} "${OBJECTDIR}/KeyPad.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Main.o: Main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Main.o.d 
	@${RM} ${OBJECTDIR}/Main.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Main.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Main.lst\" -e\"${OBJECTDIR}/Main.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Main.o\" \"Main.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Main.o"
	@${FIXDEPS} "${OBJECTDIR}/Main.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Write_Cells.o: Write_Cells.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Write_Cells.o.d 
	@${RM} ${OBJECTDIR}/Write_Cells.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Write_Cells.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Write_Cells.lst\" -e\"${OBJECTDIR}/Write_Cells.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Write_Cells.o\" \"Write_Cells.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Write_Cells.o"
	@${FIXDEPS} "${OBJECTDIR}/Write_Cells.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/config.o: config.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o.d 
	@${RM} ${OBJECTDIR}/config.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/config.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/config.lst\" -e\"${OBJECTDIR}/config.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/config.o\" \"config.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/config.o"
	@${FIXDEPS} "${OBJECTDIR}/config.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Draw_Grid.o: Draw_Grid.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Draw_Grid.o.d 
	@${RM} ${OBJECTDIR}/Draw_Grid.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Draw_Grid.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Draw_Grid.lst\" -e\"${OBJECTDIR}/Draw_Grid.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Draw_Grid.o\" \"Draw_Grid.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Draw_Grid.o"
	@${FIXDEPS} "${OBJECTDIR}/Draw_Grid.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/GLCD.o: GLCD.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/GLCD.o.d 
	@${RM} ${OBJECTDIR}/GLCD.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/GLCD.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/GLCD.lst\" -e\"${OBJECTDIR}/GLCD.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/GLCD.o\" \"GLCD.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/GLCD.o"
	@${FIXDEPS} "${OBJECTDIR}/GLCD.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/KeyPad.o: KeyPad.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/KeyPad.o.d 
	@${RM} ${OBJECTDIR}/KeyPad.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/KeyPad.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/KeyPad.lst\" -e\"${OBJECTDIR}/KeyPad.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/KeyPad.o\" \"KeyPad.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/KeyPad.o"
	@${FIXDEPS} "${OBJECTDIR}/KeyPad.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Main.o: Main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Main.o.d 
	@${RM} ${OBJECTDIR}/Main.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Main.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Main.lst\" -e\"${OBJECTDIR}/Main.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Main.o\" \"Main.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Main.o"
	@${FIXDEPS} "${OBJECTDIR}/Main.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Write_Cells.o: Write_Cells.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Write_Cells.o.d 
	@${RM} ${OBJECTDIR}/Write_Cells.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Write_Cells.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Write_Cells.lst\" -e\"${OBJECTDIR}/Write_Cells.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Write_Cells.o\" \"Write_Cells.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Write_Cells.o"
	@${FIXDEPS} "${OBJECTDIR}/Write_Cells.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/config.o: config.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o.d 
	@${RM} ${OBJECTDIR}/config.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/config.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/config.lst\" -e\"${OBJECTDIR}/config.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/config.o\" \"config.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/config.o"
	@${FIXDEPS} "${OBJECTDIR}/config.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Draw_Grid.o: Draw_Grid.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Draw_Grid.o.d 
	@${RM} ${OBJECTDIR}/Draw_Grid.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Draw_Grid.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Draw_Grid.lst\" -e\"${OBJECTDIR}/Draw_Grid.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Draw_Grid.o\" \"Draw_Grid.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Draw_Grid.o"
	@${FIXDEPS} "${OBJECTDIR}/Draw_Grid.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/Sudoku-v1.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1 -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_ICD3=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/Sudoku-v1.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/Sudoku-v1.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w  -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/Sudoku-v1.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
