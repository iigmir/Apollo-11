# Copyright:	Public domain.
# Filename:	P30_P37.agc
# Purpose: 	Part of the source code for Luminary 1A build 099.
#		It is part of the source code for the Lunar Module's (LM)
#		Apollo Guidance Computer (AGC), for Apollo 11.
# Assembler:	yaYUL
# Contact:	Ron Burkey <info@sandroid.org>.
# Website:	www.ibiblio.org/apollo.
# Pages:	614-617
# Mod history:	2009-05-17 RSB	Adapted from the corresponding
#				Luminary131 file, using page
#				images from Luminary 1A.
#		2009-06-05 RSB	Removed 4 lines of code that shouldn't
#				have survived from Luminary 131.
#
# This source code has been transcribed or otherwise adapted from
# digitized images of a hardcopy from the MIT Museum.  The digitization
# was performed by Paul Fjeld, and arranged for by Deborah Douglas of
# the Museum.  Many thanks to both.  The images (with suitable reduction
# in storage size and consequent reduction in image quality as well) are
# available online at www.ibiblio.org/apollo.  If for some reason you
# find that the images are illegible, contact me at info@sandroid.org
# about getting access to the (much) higher-quality images which Paul
# actually created.
#
# Notations on the hardcopy document read, in part:
#
#	Assemble revision 001 of AGC program LMY99 by NASA 2021112-061
#	16:27 JULY 14, 1969

# Page 614
# PROGRAM DESCRIPTION P30	DATE 3-6-67
#
# MOD.1 BY RAMA AIYAWAR
#
# FUNCTIONAL DESCRIPTIONS
#	ACCEPT ASTRONAUT INPUTS OF TIG,DELV(LV)
#	CALL IMU STATUS CHECK ROUTINE (R02)
#	DISPLAY TIME TO GO, APOGEE, PERIGEE, DELV(MAG), MGA AT IGN
#	REQUEST BURN PROGRAM
#
# CALLING SEQUENCE VIA JOB FROM V37
#
# EXIT VIA V37 CALL OR TO GOTOPOOH (V34E)
#
# SUBROUTINE CALLS --	FLAGUP, PHASCHNG, BANKCALL, ENDOFJOB, GOFLASH, GOFLASHR
#			GOPERF3R, INTPRET, BLANKET, GOTOPOOH, R02BOTH, S30.1,
#			TIG/N35, MIDGIM, DISPMGA
#
# ERASABLE INITIALIZATION -- STATE VECTOR
#
# OUTPUT -- 	RINIT, VINIT, +MGA, VTIG, RTIG, DELVSIN, DELVSAB, DELVSLV, HAPO,
#	    	HPER, TTOGO
#
# DEBRIS -- A, L, MPAC, PUSHLIST

		BANK	32
		SETLOC	P30S
		BANK
		EBANK=	+MGA
		COUNT*	$$/P30
P30		TC	UPFLAG		# SET UPDATE FLAG
		ADRES	UPDATFLG
		TC	UPFLAG		# SET TRACK FLAG
		ADRES	TRACKFLG

P30N33		CAF	V06N33		# T OF IGN
		TC	VNP00H		# RETURN ON PROCEED, P00H ON TERMINATE

		CAF	V06N81		# DISPLAY DELTA V (LV)
		TC	VNP00H		#	REDISPLAY ON RECYCLE

		TC	DOWNFLAG	# RESET UPDATE FLAG
		ADRES	UPDATFLG
		TC	INTPRET
		CALL
			S30.1
		SET	EXIT
			UPDATFLG
PARAM30		CAF	V06N42		# DISPLAY APOGEE,PERIGEE,DELTA V
		TC	VNP00H
# Page 615

		TC	INTPRET
		SETGO
			XDELVFLG	# FOR P40'S: EXTERNAL DELTA-V GUIDANCE.
			REVN1645	# TRKMKCNT, T60, +MGA  DISPLAY

V06N33		VN	0633
V06N42		VN	0642

# Page 616
# PROGRAM DESCRIPTION S30.1	DATE 9NOV66
# MOD NO 1			LOG SECTION P30,P37
# MOD BY RAMA AIYAWAR **
#
# FUNCTIONAL DESCRIPTION
#	BASED ON STORED TARGET PARAMETERS (R OF IGNITION (RTIG), V OF
#	IGNITION (VTIG), TIME OF IGNITION (TIG)), COMPUTE PERIGEE ALTITUDE
#	APOGEE ALTITUDE AND DELTAV REQUIRED (DELVSIN).
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		s30.1
#
# NORMAL EXIT MODE
#	AT L+2 OR CALLING SEQUENCE (GOTO L+2)
#
# SUBROUTINES CALLED
#	LEMPREC
#	PERIAPO
#
# ALARM OR ABORT EXIT MODES
#	NONE
#
# ERASABLE INITIALIZATION REQUIRED
#	TIG		TIME OF IGNITION	DP B28CS
#	DELVSLV		SPECIFIED DELTA-V IN LOCAL VERT.
#			COORDS. OF ACTIVE VEHICLE AT
#			TIME OF IGNITION	VECTOR B+7 METERS/CS
#
# OUTPUT
#	RTIG		POSITION AT TIG		VECTOR B+29 METERS
#	VTIG		VELOCITY AT TIG		VECTOR B+29 METERS/CS
#	PDL 4D		APOGEE ALTITUDE		DP B+29 M, B+27 METERS.
#	HAPO		APOGEE ALTITUDE		DP B+29 METERS
#	PDL 8D		PERIGEE ALTITUDE	DP B+29 M, B+27 METERS.
#	HPER		PERIGEE ALTITUDE	DP B+29 METERS
#	DELVSIN		SPECIFIED DELTA-V IN INTERTIAL
#			COORD. OF ACTIVE VEHICLE AT
#			TIME OF IGNITION	VECTOR B+7 METERS/CS
#	DELVSAB		MAG. OF DELVSIN		VECTOR B+7 METERS/CS
#
# DEBRIS	QTEMP	TEMP.ERASABLE
#		QPRET, MPAC
#		PUSHLIST

		SETLOC	P30S1
		BANK

		COUNT*	$$/S30S

S30.1		STQ	DLOAD
			QTEMP
			TIG		# TIME IGNITION SCALED AT 2(+28)CS
		STCALL	TDEC1
			LEMPREC		# ENCKE ROUTINE FOR LEM

		VLOAD	SXA,2
# Page 617
			RATT
			RTX2
		STORE	RTIG		# RADIUS VECTOR AT IGNITION TIME
		UNIT	VCOMP
		STOVL	DELVSIN		# ZRF/LV IN DELVSIN SCALED AT 2
			VATT		# VELOCITY VECTOR AT TIG, SCALED 2(7) M/CS
		STORE	VTIG
		VXV	UNIT
			RTIG
		SETPD	SXA,1
			0
			RTX1
		PUSH	VXV		# YRF/LV PDL 0 SCALED AT 2
			DELVSIN
		VSL1	PDVL
		PDVL	PDVL		# YRF/LV PDL 6 SCALED AT 2
			DELVSIN		# ZRF/LV PDL 12D SCALED AT 2
			DELVSLV
		VXM	VSL1
			0
		STORE	DELVSIN		# DELTAV IN INERT. COOR. SCALED TO B+7M/CS
		ABVAL
		STOVL	DELVSAB		# DELTA V MAG.
			RTIG		# (FOR PERIAPO)
		PDVL	VAD		# VREQUIRED = VTIG + DELVSIN (FOR PERIAPO)
			VTIG
			DELVSIN
		CALL
			PERIAPO1
		CALL
			SHIFTR1		# RESCALE IF NEEDED
		CALL			# LIMIT DISPLAY TO 9999.9 N. MI.
			MAXCHK
		STODL	HPER		# PERIGEE ALT 2(29) METERS FOR DISPLAY
			4D
		CALL
			SHIFTR1		# RESCALE IF NEEDED
		CALL			# LIMIT DISPLAY TO 9999.9 N. MI.
			MAXCHK
		STCALL	HAPO		# APOGEE ALT 2(29) METERS FOR DISPLAY
			QTEMP


