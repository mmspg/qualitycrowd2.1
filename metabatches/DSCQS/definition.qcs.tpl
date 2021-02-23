#
# DSCQS evaluation template
#

meta title {batch_id}
meta description "DSCQS Evaluation"

meta workers 500
meta timeout 300

var fivelevels "5: Excellent; 4: Good; 3: Fair; 2: Poor; 1: Bad"

set mediaurl "/media/jpegai/"

# Set True for debugging
# set skipvalidation True

#
# Macro and list definitions
#

macro qualityquestion
  set answermode continous
  set answers $fivelevels
  question "Rate visual quality A"
  question "Rate visual quality B"
end macro

list stimuli
{stimuli_list}
end list

#
# The Steps
#

step "Age and Gender"
  set answermode strings
  set answers "age: How old are you?"
  title ""
  text "Please provide your information"
  question ""
  set answermode discrete
  set answers "1: Male; 2: Female"
  title ""
  question "What is your gender?"
end step

step "Instruction page"
  title "Instructions"
  text include(page.instructions.html)
end step

set delay 0

step "Training Bad-Excellent"
  title "This is an example of Bad (A) and Excellent (B) quality"
  text "Sample A &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sample B"
  image crop_J2K-KDU-VIS_00014_TE_3680x2456_8bit_sRGB_006.png 00014_TE_3680x2456.png
  $qualityquestion
end step

step "Training Excellent-Excellent"
  title "This is an example of Excellent (A) and Excellent (B) quality"
  text "Sample A &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sample B"
  image 00014_TE_3680x2456.png 00014_TE_3680x2456.png
  $qualityquestion
end step

step "Training Fair-Excellent"
  title "This is an example of Excellent (A) and Fair (B) quality"
  text "Sample A &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sample B"
  image 00014_TE_3680x2456.png crop_J2K-KDU-VIS_00014_TE_3680x2456_8bit_sRGB_025.png
  $qualityquestion
end step

step "Starting Evaluation"
  title "Press Next to start rating images"
end step

for imagepair in stimuli
  step "$imagepair"
    text "Sample A &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sample B"
    image $imagepair
    $qualityquestion
  end step
end for

step
	title "Thank you!"
  text "Your confirmation token: {conf_token}"
end step
