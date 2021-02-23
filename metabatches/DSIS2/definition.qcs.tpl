#
# An Example of DSIS2
#

meta title {batch_id}

meta workers 30
meta timeout 300

var fivepoints "5: Imperceptible; 4: Perceptible but not annoying; 3: Slightly Annoying; 2: Annoying; 1: Very Annoying"

set mediaurl "/media/dsis2ss/"
set videowidth 1920
set videoheight 1080

#
# Macro and list definitions
#

macro qualityquestion
  set answermode discrete
  set width 600
  set answers $fivepoints
  question "Please rate the visual quality"
end macro

list training
  MarathonR0_1920x1080_30p_VP9_QP25.mp4
  MarathonR0_1920x1080_30p_VP9_QP52.mp4
  MarathonR0_1920x1080_30p_VP9_QP63.mp4
end list

list myvideos
{stimuli_list}
end list

#
# The Steps
#

# step "Name and age question"
# 	set answermode strings
# 	set answers "name: What is your name?; age: How old are you?"
# 	title ""
# 	text "Please provide your information"
# 	question ""
# end step
#
# step "gender question"
#        set answermode discrete
#        set answers "1: Male; 2: Female"
#        title ""
#        text "Please provide your information"
#        question "What is your gender?"
# end step

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

set answermode discrete
set answers $fivepoints

step "Training - Very Annoying"
      title "This is an example of very annoying impairment"
      text "You should rate this video as 1 - Very annoying"
       video MarathonR0_1920x1080_30p_VP9_QP63.mp4
       $qualityquestion
end step

step "Training - Imperceptible"
       title "This is an example of imperceptible impairment"
       text "You should rate this video as 5 - Imperceptible"
       video MarathonR0_1920x1080_30p_VP9_QP25.mp4
       $qualityquestion
end step

step "Training - Slightly Annoying"
       title "This is an example of slightly annoying impairment"
       text "You should rate this video as 3 - Slightly annoying"
       video MarathonR0_1920x1080_30p_VP9_QP52.mp4
       $qualityquestion
end step

for video in myvideos
  step $video
      video $video
      $qualityquestion
  end step
end for

step
	title "Thank you!"
  text "Your confirmation token: {conf_token}"
end step
