#!/bin/sh


mixer() {
  parm=${4:-on}
  amixer -c "$1" sset "$2" "$3" $parm >/dev/null 2>&1
  amixer -c "$1" sset "$2" $parm >/dev/null 2>&1
}


if [ -f $HOME/.config/sound.conf ]; then

  alsactl restore -f $HOME/.config/sound.conf

else

# get card num
#card=`echo $1 | sed 's/[^0-9]*//g'`
card1=`aplay -l | grep "device 0" | awk '{print $3}'`
#echo $card

for card in $card1 
do

echo $card

# set common mixer params
  mixer $card Master 0db
  mixer $card Front 100%
  mixer $card PCM 0db
  mixer $card Synth 100%

# mute CD, since using digital audio instead
  mixer $card CD 0% mute

# Only unmute Line and Aux if they are possibly used.
#  mixer $card Line 100%
#  mixer $card Aux 100%

# mute mic
  mixer $card Mic 0% mute

# ESS 1969 chipset has 2 PCM channels
  mixer $card PCM,1 100%

# set digital output mixer params
  mixer $card 'IEC958' 100% on
  mixer $card 'IEC958 Output' 100%
  mixer $card 'IEC958 Coaxial' 100%
  mixer $card 'IEC958 LiveDrive' 100%
  mixer $card 'IEC958 Optical Raw' 100%
  mixer $card 'SPDIF Out' 100%
  mixer $card 'SPDIF Front' 100%
  mixer $card 'SPDIF Rear' 100%
  mixer $card 'SPDIF Center/LFE' 100%
  mixer $card 'Master Digital' 100%

  mixer $card 'Analog Front' 100%
  mixer $card 'Analog Rear' 100%
  mixer $card 'Analog Center/LFE' 100%

# Amlogic G12 HDMI to PCM0 - OLD CONF
  mixer $card 'FRDDR_A SINK 1 SEL' 'OUT 1'
  mixer $card 'FRDDR_A SRC 1 EN' on
  mixer $card 'TDMOUT_B SRC SEL' 'IN 0'
  mixer $card 'TOHDMITX I2S SRC' 'I2S B'
  mixer $card 'TOHDMITX' on

# Amlogic G12 HDMI to PCM0 - NEW CONF
#   mixer $card 'FRDDR_A SINK 1 SEL' 'OUT 0'
#   mixer $card 'FRDDR_A SRC 1 EN' on
#   mixer $card 'TDMOUT_A SRC SEL' 'IN 0'
#   mixer $card 'TOHDMITX' on
#   mixer $card 'TOHDMITX I2S SRC' 'I2S A'

# Amlogic G12 S/PDIF to PCM1
  mixer $card 'FRDDR_B SINK 1 SEL' 'OUT 3'
  mixer $card 'FRDDR_B SRC 1 EN' on
  mixer $card 'SPDIFOUT SRC SEL' 'IN 1'
  mixer $card 'SPDIFOUT Playback' on

# Amlogic G12 Headphone Jack to PCM2
  mixer "$card" 'TOACODEC Lane Select' 0
  mixer "$card" 'TOACODEC OUT EN' on
  mixer "$card" 'TOACODEC SRC' 'I2S c'
  mixer "$card" 'ACODEC' dB gain: 0.00, 0.00
  mixer "$card" 'ACODEC Playback Channel Mode' Stereo
  mixer "$card" 'ACODEC Left DAC Sel' Left
  mixer "$card" 'ACODEC Right DAC Sel' Right

# Amlogic GX HDMI and S/PDIF
  mixer $card 'AIU HDMI CTRL SRC' 'I2S'
  mixer $card 'AIU SPDIF SRC SEL' 'SPDIF'

done

fi

exit 0
