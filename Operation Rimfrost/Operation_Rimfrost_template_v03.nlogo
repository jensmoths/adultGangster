; Template used for Software Integration
;
;
; Version History: (set date, changes and by whom everytime you add or change something)
; 2020-03-30 Initial Template by Gion K Svedberg
; 2020-04-21 integration to common template in class
; 2021-04-22 Group 8 changes for this years template
;
;

; ************ INCLUDED FILES *****************
__includes [
  "map.nls"
  "adult-gangster.nls"
  "police.nls"
  "child-gangster.nls"
  "child.nls"
  "adult.nls"
  "house.nls"
  "gang-hideout.nls"
  "stash-house.nls"
  "school.nls"
  "playground.nls"
  "prison.nls"
  "workplace.nls"
  "police-station.nls"
  "drug-delivery-spot.nls"
  "bdi.nls"
  "communication.nls"
  "meetingplace.nls"
]

; ********************end included files ********

; ************ EXTENSIONS *****************
extensions [
vid
array ] ; used for recording simulation

; ********************end extensions ********

; ************ BREEDS OF TURTLES *****************
breed [ adults adult ]
breed [ adult-gangsters adult-gangster ]
breed [ police a-police ]
breed [ children child ]
breed [ child-gangsters child-gangster ]
breed [ houses house ]
breed [ schools school ]
breed [ police-stations police-station ]
breed [ gang-hideouts gang-hideout ]
breed [ stash-houses stash-house ]
breed [ drug-delivery-spots drug-delivery-spot ]
breed [ playgrounds playground ]
breed [ workplaces workplace ]
breed [ prisons prison ]
breed [ meetingplaces meetingplace ]

; ********************end breed of turtles ********

; ************* GLOBAL VARIABLES *****************
globals [
  time
  places
  people
]

; ******************end global variables ***********

; ************* AGENT-SPECIFIC VARIABLES *********
turtles-own[
  beliefs
  intentions
  incoming-queue
  observeEnvironment
  processMsg
  reactiveIntention
  deliberateIntentions
  status
]

; *********************end agent-specific variables *************

; ******************* SETUP PART *****************
to setup
  clear-all

  ; Setup map/houses
  setup-map
  setup-gang-hideouts
  setup-houses
  setup-stash-houses
  setup-schools
  setup-playgrounds
  setup-workplaces
  setup-police-stations
  setup-drug-delivery-spots
  setup-prisons
  setup-meetingplaces

  ; Setup people
  setup-police
  setup-adult-gangsters
  setup-child-gangsters
  setup-children
  setup-adults

  ; Setup places and people (turtle-sets)
  setup-turtle-sets
  set time 0

  reset-ticks

  ; Video recording
  if vid:recorder-status = "recording" [ vid:record-view ]
end
; **************************end setup part *******

; ******************* TO GO/ STARTING PART ********
; cyclic execution of agents
to go

 ask people[
;    ;humanBehaviour ;eg update time awake, hunger. Maybe implement later?
    run observeEnvironment
    ;what does the agents see and thereby belief. Question for later: What are agents vision range? neighbors? different range for different agents?
   run processMsg
    ;read and process messages and update beliefs
;
;    if (not reactiveIntention)
;    ;if no reactive intention has been added to stack
;    [
      if (empty? intentions)
      [
      run deliberateIntentions ;decides what intention to achieve next and put it on stack
;      ]
    ]
;
    execute-intentions ;execute top-of-stack intention and remove it from stack
;  ]
  ]

  tick

  ; Change time, 0-23
  set time time + 1

  if time = 2300
  [set time 0]
  ;;print time

  ; Show/Hide breed label
  ask places [ show-labels ]

  ; Video recording
  if vid:recorder-status = "recording" [ vid:record-view ]
end

;************************end to go/starting part ***********

; ************** FUNCTION and REPORT PART **************

to setup-turtle-sets
  set places (turtle-set gang-hideouts houses stash-houses schools playgrounds workplaces police-stations drug-delivery-spots meetingplaces) ;Not included atm: prisons
  set people (turtle-set police adults adult-gangsters children child-gangsters)
end

to show-labels
  set label-color 139
  ifelse show-building-labels
    [ set label word breed who ]
    [ set label "" ]
end

to test
  ask adults[
  let msg create-message "request"
  set msg add-receiver 225 msg
  set msg add-content "orderDrugs" msg
    send msg]

end

;************** end function and report part **************

; ************** VIDEO RECORDING FUNCTIONS **************
; code for vid-recording of simulation
to start-recorder
  carefully [ vid:start-recorder ] [ user-message error-message ]
end

to reset-recorder
  let message (word
    "If you reset the recorder, the current recording will be lost."
    "Are you sure you want to reset the recorder?")
  if vid:recorder-status = "inactive" or user-yes-or-no? message [
    vid:reset-recorder
  ]
end

to save-recording
  if vid:recorder-status = "inactive" [
    user-message "The recorder is inactive. There is nothing to save."
    stop
  ]
  ; prompt user for movie location
  user-message (word
    "Choose a name for your movie file (the "
    ".mp4 extension will be automatically added).")
  let path user-new-file
  if not is-string? path [ stop ]  ; stop if user canceled
  ; export the movie
  carefully [
    vid:save-recording path
    user-message (word "Exported movie to " path ".")
  ] [
    user-message error-message
  ]
end
; ************** end video recording functions **************




; ************** EXTRA FUNCTIONS ************** TODO

; Reports true or false with a probability of 'slider-value'.
;
; slider-value (input): A slider value from 0 to 100, representing the probability in percentage.
;to-report process-probability [ slider-value ]
;  let p false
;  if random 100 >= (100 - slider-value) [
;    set p true
;  ]
;  report p
;end

; Reports a TRIST-value based on the number of gangsters in prison divided by the total number of gangsters
;to-report trist-value
;  let trist 0
;  let total-gangsters count adult-gangsters with [ inPrison? = true ]
;  let gangsters-in-prison total-gangsters
;  set trist gangsters-in-prison / total-gangsters
;  report trist
;end
@#$#@#$#@
GRAPHICS-WINDOW
346
10
1407
604
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-40
40
-22
22
1
1
1
ticks
30.0

BUTTON
9
14
73
47
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
87
14
151
48
Go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
166
14
240
48
Go-loop
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
8
593
154
626
show_messages
show_messages
0
1
-1000

SLIDER
8
65
180
98
nbr-of-children
nbr-of-children
0
140
5.0
1
1
NIL
HORIZONTAL

SLIDER
8
102
180
135
nbr-of-adults
nbr-of-adults
0
140
1.0
1
1
NIL
HORIZONTAL

SLIDER
8
139
180
172
nbr-of-police
nbr-of-police
0
40
3.0
1
1
NIL
HORIZONTAL

SLIDER
8
176
185
209
nbr-of-adult-gangsters
nbr-of-adult-gangsters
0
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
8
213
181
246
nbr-of-child-gangsters
nbr-of-child-gangsters
0
100
6.0
1
1
NIL
HORIZONTAL

SLIDER
8
250
180
283
nbr-of-houses
nbr-of-houses
3
40
15.0
1
1
NIL
HORIZONTAL

SLIDER
8
287
180
320
nbr-of-schools
nbr-of-schools
1
6
3.0
1
1
NIL
HORIZONTAL

SLIDER
8
324
180
357
nbr-of-playgrounds
nbr-of-playgrounds
1
16
2.0
1
1
NIL
HORIZONTAL

SLIDER
8
361
180
394
nbr-of-police-stations
nbr-of-police-stations
1
3
1.0
1
1
NIL
HORIZONTAL

SLIDER
8
398
180
431
nbr-of-gang-hideouts
nbr-of-gang-hideouts
2
12
4.0
1
1
NIL
HORIZONTAL

SLIDER
8
435
180
468
nbr-of-stash-houses
nbr-of-stash-houses
2
12
4.0
1
1
NIL
HORIZONTAL

SLIDER
8
472
180
505
nbr-of-workplaces
nbr-of-workplaces
3
15
4.0
1
1
NIL
HORIZONTAL

SLIDER
8
509
205
542
nbr-of-drug-delivery-spots
nbr-of-drug-delivery-spots
2
50
9.0
1
1
NIL
HORIZONTAL

SWITCH
163
593
306
626
show-intentions
show-intentions
0
1
-1000

SWITCH
8
636
174
669
show-building-labels
show-building-labels
1
1
-1000

SLIDER
8
546
180
579
nbr-of-meetingplaces
nbr-of-meetingplaces
0
10
3.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bowser
false
1
Rectangle -955883 true false 135 285 150 300
Rectangle -955883 true false 105 285 120 300
Rectangle -955883 true false 75 255 90 300
Rectangle -955883 true false 90 240 135 285
Rectangle -955883 true false 45 240 60 285
Rectangle -955883 true false 30 240 45 270
Rectangle -955883 true false 15 225 30 255
Rectangle -955883 true false 60 225 75 240
Rectangle -955883 true false 45 210 90 225
Rectangle -955883 true false 30 195 60 210
Rectangle -955883 true false 30 180 45 195
Rectangle -955883 true false 105 210 135 225
Rectangle -955883 true false 120 195 135 210
Rectangle -955883 true false 135 225 225 240
Rectangle -955883 true false 150 255 210 270
Rectangle -955883 true false 195 285 240 300
Rectangle -955883 true false 255 285 270 300
Rectangle -955883 true false 210 270 255 285
Rectangle -955883 true false 225 255 255 270
Rectangle -955883 true false 240 225 255 255
Rectangle -955883 true false 255 210 270 240
Rectangle -955883 true false 270 210 285 225
Rectangle -955883 true false 225 195 240 210
Rectangle -955883 true false 240 180 255 195
Rectangle -955883 true false 60 150 75 180
Rectangle -955883 true false 75 165 90 195
Rectangle -955883 true false 90 180 105 195
Rectangle -955883 true false 90 135 105 150
Rectangle -955883 true false 105 120 120 165
Rectangle -16777216 true false 45 165 60 195
Rectangle -16777216 true false 60 180 75 210
Rectangle -16777216 true false 75 195 90 210
Rectangle -16777216 true false 75 150 90 165
Rectangle -16777216 true false 90 150 105 180
Rectangle -16777216 true false 105 165 120 180
Rectangle -16777216 true false 120 120 135 165
Rectangle -16777216 true false 135 150 150 180
Rectangle -16777216 true false 150 165 165 180
Rectangle -16777216 true false 150 180 240 195
Rectangle -16777216 true false 255 180 270 210
Rectangle -16777216 true false 240 195 255 225
Rectangle -16777216 true false 225 210 240 225
Rectangle -16777216 true false 255 120 270 135
Rectangle -16777216 true false 210 105 225 120
Rectangle -1 true false 195 105 210 120
Rectangle -1 true false 195 150 210 165
Rectangle -1 true false 225 150 240 165
Rectangle -1 true false 105 105 135 120
Rectangle -1 true false 90 120 105 135
Rectangle -1 true false 75 225 90 240
Rectangle -1 true false 90 210 105 225
Rectangle -6459832 true false 60 240 75 285
Rectangle -6459832 true false 75 240 90 255
Rectangle -6459832 true false 90 225 135 240
Rectangle -6459832 true false 135 240 150 285
Rectangle -6459832 true false 150 270 165 285
Rectangle -1184463 true false 165 270 195 285
Rectangle -1184463 true false 150 240 225 255
Rectangle -1184463 true false 135 195 225 225
Rectangle -6459832 true false 195 270 210 285
Rectangle -6459832 true false 210 255 225 270
Rectangle -6459832 true false 225 225 240 255
Rectangle -1184463 true false 165 165 255 180
Rectangle -1184463 true false 150 150 180 165
Rectangle -1184463 true false 150 120 180 135
Rectangle -1184463 true false 150 135 165 150
Rectangle -1184463 true false 180 135 285 150
Rectangle -1184463 true false 270 120 285 135
Rectangle -1184463 true false 240 105 270 120
Rectangle -1184463 true false 225 120 255 135
Rectangle -2064490 true false 165 90 180 105
Rectangle -2064490 true false 150 60 165 105
Rectangle -1 true false 60 105 75 120
Rectangle -10899396 true false 90 75 105 90
Rectangle -10899396 true false 105 75 120 90
Rectangle -6459832 true false 90 195 120 210
Rectangle -6459832 true false 105 180 150 195
Rectangle -6459832 true false 120 165 135 180
Rectangle -2674135 true true 165 135 180 150
Rectangle -2674135 true true 180 150 195 165
Rectangle -2674135 true true 210 150 225 165
Rectangle -2674135 true true 225 105 240 120
Rectangle -2674135 true true 180 90 225 105
Rectangle -2674135 true true 165 75 195 90
Rectangle -2674135 true true 180 60 195 75
Rectangle -2674135 true true 225 75 240 90
Rectangle -2674135 true true 210 45 225 75
Rectangle -2674135 true true 195 30 210 60
Rectangle -2674135 true true 180 30 195 45
Rectangle -2674135 true true 165 45 180 60
Rectangle -2674135 true true 150 30 165 45
Rectangle -2674135 true true 135 60 135 60
Rectangle -2674135 true true 120 45 135 60
Rectangle -2674135 true true 135 60 150 90
Rectangle -10899396 true false 90 90 120 105
Rectangle -10899396 true false 75 105 105 120
Rectangle -10899396 true false 135 90 150 150
Rectangle -1 true false 120 75 135 105
Rectangle -10899396 true false 150 105 195 120
Rectangle -10899396 true false 180 120 225 135
Rectangle -10899396 true false 195 75 225 90
Rectangle -10899396 true false 225 90 240 105
Rectangle -6459832 true false 195 60 210 75
Rectangle -6459832 true false 180 45 195 60
Rectangle -6459832 true false 165 60 180 75
Rectangle -6459832 true false 135 45 165 60
Rectangle -6459832 true false 90 90 105 105
Rectangle -1 true false 75 135 90 150
Rectangle -1 true false 75 135 90 150
Rectangle -6459832 true false 90 90 105 105
Rectangle -6459832 true false 75 120 90 135
Rectangle -6459832 true false 90 75 105 90
Rectangle -6459832 true false 60 105 75 135
Rectangle -1 true false 30 135 45 165
Rectangle -10899396 true false 75 90 90 105
Rectangle -1 true false 45 150 60 165
Rectangle -10899396 true false 45 135 75 150
Rectangle -10899396 true false 45 120 60 135

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

computer workstation
false
0
Rectangle -7500403 true true 60 45 240 180
Polygon -7500403 true true 90 180 105 195 135 195 135 210 165 210 165 195 195 195 210 180
Rectangle -16777216 true false 75 60 225 165
Rectangle -7500403 true true 45 210 255 255
Rectangle -10899396 true false 249 223 237 217
Line -16777216 false 60 225 120 225

courthouse
false
0
Rectangle -13791810 true false 30 285 270 300
Rectangle -13791810 true false 30 135 45 285
Rectangle -13791810 true false 135 0 165 30
Rectangle -13791810 true false 120 15 135 45
Rectangle -13791810 true false 105 30 120 60
Rectangle -13791810 true false 90 45 105 75
Rectangle -13791810 true false 75 60 90 90
Rectangle -13791810 true false 60 75 75 105
Rectangle -13791810 true false 45 90 60 120
Rectangle -13791810 true false 30 105 45 135
Rectangle -13791810 true false 15 120 30 135
Rectangle -13791810 true false 0 135 30 150
Rectangle -13791810 true false 165 15 180 45
Rectangle -13791810 true false 180 30 195 60
Rectangle -13791810 true false 195 45 210 75
Rectangle -13791810 true false 210 60 225 90
Rectangle -13791810 true false 225 75 240 105
Rectangle -13791810 true false 240 90 255 120
Rectangle -13791810 true false 255 105 270 135
Rectangle -13791810 true false 270 120 285 150
Rectangle -13791810 true false 285 135 300 150
Rectangle -13791810 true false 255 135 270 285
Rectangle -13345367 true false 90 150 105 285
Rectangle -13345367 true false 45 150 120 165
Rectangle -13345367 true false 180 150 255 165
Rectangle -1 true false 195 165 210 285
Rectangle -1 true false 60 165 75 285
Rectangle -13345367 true false 225 165 240 285
Rectangle -13345367 true false 45 285 255 300
Rectangle -11221820 true false 45 165 60 285
Rectangle -13791810 true false 75 165 90 285
Rectangle -13791810 true false 210 165 225 285
Rectangle -11221820 true false 240 165 255 285
Rectangle -11221820 true false 105 165 195 285
Rectangle -7500403 true true 135 195 165 285
Rectangle -13345367 true false 105 285 195 300
Rectangle -13791810 true false 120 270 180 285
Rectangle -13791810 true false 120 150 180 165
Rectangle -13791810 true false 105 165 195 180
Rectangle -13791810 true false 210 165 225 180
Rectangle -13791810 true false 240 165 255 180
Rectangle -13791810 true false 75 165 90 180
Rectangle -13791810 true false 45 165 60 180
Rectangle -13791810 true false 45 135 255 150
Rectangle -11221820 true false 45 120 255 135
Rectangle -13345367 true false 120 105 180 120
Rectangle -13345367 true false 120 90 135 105
Rectangle -13345367 true false 135 75 165 90
Rectangle -13345367 true false 165 90 180 105
Rectangle -11221820 true false 75 90 120 120
Rectangle -11221820 true false 60 105 75 120
Rectangle -11221820 true false 90 75 135 90
Rectangle -11221820 true false 120 45 180 75
Rectangle -11221820 true false 105 60 120 75
Rectangle -11221820 true false 135 30 165 45
Rectangle -11221820 true false 165 75 210 90
Rectangle -11221820 true false 180 60 195 120
Rectangle -11221820 true false 195 90 225 120
Rectangle -11221820 true false 225 105 240 120
Rectangle -1 true false 135 90 165 105

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

factory
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

gang hideout
false
9
Rectangle -6459832 true false 15 285 285 300
Rectangle -16777216 true false 135 0 165 30
Rectangle -16777216 true false 120 15 135 45
Rectangle -16777216 true false 105 30 120 60
Rectangle -16777216 true false 90 45 105 75
Rectangle -16777216 true false 75 60 90 90
Rectangle -16777216 true false 60 75 75 105
Rectangle -16777216 true false 45 90 60 120
Rectangle -16777216 true false 30 105 45 135
Rectangle -16777216 true false 15 120 30 135
Rectangle -16777216 true false 0 135 300 150
Rectangle -16777216 true false 255 120 285 135
Rectangle -16777216 true false 240 105 270 120
Rectangle -16777216 true false 225 90 255 105
Rectangle -16777216 true false 210 75 240 90
Rectangle -16777216 true false 195 60 225 75
Rectangle -16777216 true false 180 45 210 60
Rectangle -16777216 true false 165 30 195 45
Rectangle -16777216 true false 165 15 180 30
Rectangle -16777216 true false 30 150 45 285
Rectangle -16777216 true false 255 150 270 285
Rectangle -13791810 true true 45 150 255 285
Rectangle -16777216 true false 60 105 240 120
Rectangle -13791810 true true 45 120 255 135
Rectangle -13791810 true true 75 90 225 105
Rectangle -16777216 true false 90 75 210 90
Rectangle -13791810 true true 105 60 195 75
Rectangle -16777216 true false 120 45 180 60
Rectangle -13791810 true true 135 30 165 45
Rectangle -16777216 true false 45 165 255 180
Rectangle -16777216 true false 45 195 255 210
Rectangle -16777216 true false 45 225 255 240
Rectangle -16777216 true false 45 255 255 270
Rectangle -16777216 true false 75 180 135 285
Rectangle -11221820 true false 180 195 225 240
Rectangle -16777216 true false 165 180 180 255
Rectangle -16777216 true false 180 180 240 195
Rectangle -16777216 true false 225 195 240 255
Rectangle -16777216 true false 180 240 225 255
Rectangle -7500403 true false 90 195 120 285
Rectangle -6459832 true false 90 225 105 240

garbage can
false
0
Polygon -16777216 false false 60 240 66 257 90 285 134 299 164 299 209 284 234 259 240 240
Rectangle -7500403 true true 60 75 240 240
Polygon -7500403 true true 60 238 66 256 90 283 135 298 165 298 210 283 235 256 240 238
Polygon -7500403 true true 60 75 66 57 90 30 135 15 165 15 210 30 235 57 240 75
Polygon -7500403 true true 60 75 66 93 90 120 135 135 165 135 210 120 235 93 240 75
Polygon -16777216 false false 59 75 66 57 89 30 134 15 164 15 209 30 234 56 239 75 235 91 209 120 164 135 134 135 89 120 64 90
Line -16777216 false 210 120 210 285
Line -16777216 false 90 120 90 285
Line -16777216 false 125 131 125 296
Line -16777216 false 65 93 65 258
Line -16777216 false 175 131 175 296
Line -16777216 false 235 93 235 258
Polygon -16777216 false false 112 52 112 66 127 51 162 64 170 87 185 85 192 71 180 54 155 39 127 36

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house 1
false
4
Rectangle -6459832 true false 0 285 300 300
Rectangle -1184463 true true 30 135 270 285
Rectangle -16777216 true false 0 135 15 150
Rectangle -16777216 true false 150 135 300 150
Rectangle -955883 true false 15 135 30 285
Rectangle -955883 true false 135 135 150 285
Rectangle -955883 true false 150 150 285 165
Rectangle -955883 true false 270 150 285 285
Rectangle -1184463 true true 45 105 135 135
Rectangle -1184463 true true 60 75 120 105
Rectangle -1184463 true true 75 45 105 75
Rectangle -955883 true false 30 105 45 135
Rectangle -955883 true false 45 75 60 105
Rectangle -955883 true false 60 45 75 75
Rectangle -955883 true false 75 15 90 45
Rectangle -16777216 true false 90 15 105 45
Rectangle -16777216 true false 135 105 150 135
Rectangle -16777216 true false 15 105 30 135
Rectangle -16777216 true false 30 75 45 105
Rectangle -16777216 true false 45 45 60 75
Rectangle -16777216 true false 60 15 75 45
Rectangle -16777216 true false 75 0 225 15
Rectangle -16777216 true false 270 105 285 135
Rectangle -16777216 true false 255 75 270 105
Rectangle -16777216 true false 240 45 255 75
Rectangle -16777216 true false 225 15 240 45
Rectangle -16777216 true false 120 75 135 105
Rectangle -16777216 true false 105 45 120 75
Rectangle -16777216 true false 105 15 225 45
Rectangle -16777216 true false 120 45 240 75
Rectangle -16777216 true false 135 75 255 105
Rectangle -16777216 true false 150 105 270 135
Rectangle -955883 true false 60 195 105 285
Rectangle -16777216 true false 75 210 90 285
Rectangle -16777216 true false 60 105 105 165
Rectangle -13791810 true false 75 120 90 150
Rectangle -16777216 true false 180 195 240 255
Rectangle -13791810 true false 195 210 225 240

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

mario adult
true
0
Rectangle -1184463 true false 150 255 165 270
Rectangle -1184463 true false 180 270 195 285
Rectangle -16777216 true false 90 255 105 270
Rectangle -16777216 true false 165 255 180 270
Rectangle -16777216 true false 90 285 210 300
Rectangle -16777216 true false 150 270 165 285
Rectangle -6459832 true false 180 270 195 285
Rectangle -13791810 true false 105 270 150 285
Rectangle -16777216 true false 180 255 195 270
Rectangle -16777216 true false 135 255 165 270
Rectangle -13791810 true false 165 255 180 270
Rectangle -16777216 true false 195 270 210 285
Rectangle -13791810 true false 165 270 195 285
Rectangle -13791810 true false 105 255 135 270
Rectangle -13791810 true false 120 225 135 255
Rectangle -13345367 true false 135 210 150 225
Rectangle -13791810 true false 75 210 90 255
Rectangle -13791810 true false 90 180 135 210
Rectangle -13345367 true false 120 165 180 180
Rectangle -955883 true false 90 150 120 165
Rectangle -13345367 true false 165 240 180 255
Rectangle -13345367 true false 195 240 210 255
Rectangle -13345367 true false 210 195 225 240
Rectangle -13345367 true false 195 180 210 195
Rectangle -13345367 true false 180 165 195 180
Rectangle -13345367 true false 180 240 195 255
Rectangle -13345367 true false 135 225 165 255
Rectangle -13345367 true false 165 225 180 240
Rectangle -13345367 true false 135 180 150 210
Rectangle -13345367 true false 150 180 165 195
Rectangle -13345367 true false 180 210 195 240
Rectangle -11221820 true false 165 180 180 195
Rectangle -13345367 true false 195 225 210 240
Rectangle -13345367 true false 150 195 180 225
Rectangle -13345367 true false 195 195 210 225
Rectangle -1 true false 90 210 120 255
Rectangle -1 true false 120 210 135 225
Rectangle -13345367 true false 105 165 120 180
Rectangle -13345367 true false 75 180 90 210
Rectangle -13345367 true false 90 165 105 180
Rectangle -16777216 true false 75 135 90 165
Rectangle -16777216 true false 60 120 75 150
Rectangle -16777216 true false 45 90 60 135
Rectangle -16777216 true false 60 60 75 90
Rectangle -16777216 true false 75 45 90 60
Rectangle -16777216 true false 90 30 105 45
Rectangle -16777216 true false 105 15 135 30
Rectangle -16777216 true false 135 0 210 15
Rectangle -16777216 true false 210 15 225 45
Rectangle -16777216 true false 120 60 255 75
Rectangle -16777216 true false 150 45 240 60
Rectangle -16777216 true false 180 75 195 105
Rectangle -16777216 true false 150 75 165 105
Rectangle -16777216 true false 90 75 135 90
Rectangle -16777216 true false 105 90 120 135
Rectangle -16777216 true false 120 105 135 120
Rectangle -16777216 true false 150 120 165 135
Rectangle -16777216 true false 135 135 240 150
Rectangle -16777216 true false 165 150 225 165
Rectangle -13791810 true false 135 15 210 45
Rectangle -13791810 true false 105 30 150 60
Rectangle -13791810 true false 90 45 120 75
Rectangle -13791810 true false 75 60 90 75
Rectangle -955883 true false 210 90 240 105
Rectangle -955883 true false 240 105 255 135
Rectangle -955883 true false 165 120 240 135
Rectangle -955883 true false 135 105 240 120
Rectangle -955883 true false 195 90 210 105
Rectangle -955883 true false 165 90 180 105
Rectangle -955883 true false 135 90 150 105
Rectangle -955883 true false 120 120 150 135
Rectangle -955883 true false 120 135 135 150
Rectangle -955883 true false 195 75 210 90
Rectangle -955883 true false 165 75 180 90
Rectangle -955883 true false 135 75 150 90
Rectangle -955883 true false 120 90 135 105
Rectangle -955883 true false 90 135 120 150
Rectangle -955883 true false 120 150 165 165
Rectangle -955883 true false 60 90 75 105
Rectangle -955883 true false 90 90 105 135
Rectangle -6459832 true false 75 90 90 120
Rectangle -955883 true false 60 105 75 120
Rectangle -955883 true false 75 120 90 135
Rectangle -13345367 true false 135 165 150 180
Rectangle -13791810 true false 150 165 180 180
Rectangle -13791810 true false 150 180 195 195
Rectangle -13791810 true false 165 195 195 210
Rectangle -16777216 true false 90 270 105 285
Rectangle -1184463 true false 165 210 180 225
Rectangle -1184463 true false 195 210 210 225
Rectangle -955883 true false 75 75 90 90
Rectangle -16777216 true false 75 75 90 90
Rectangle -16777216 true false 60 180 75 255
Rectangle -16777216 true false 75 255 90 270
Rectangle -16777216 true false 75 165 90 180
Rectangle -16777216 true false 210 180 225 195
Rectangle -16777216 true false 225 195 240 240
Rectangle -16777216 true false 210 240 225 255
Rectangle -16777216 true false 195 255 210 270
Rectangle -16777216 true false 195 165 210 180

mario gangster
true
1
Rectangle -1184463 true false 150 255 165 270
Rectangle -1184463 true false 180 270 195 285
Rectangle -16777216 true false 135 285 195 270
Rectangle -2674135 true true 165 270 180 285
Rectangle -16777216 true false 90 255 105 270
Rectangle -16777216 true false 165 255 180 270
Rectangle -16777216 true false 90 285 210 300
Rectangle -16777216 true false 150 270 165 285
Rectangle -6459832 true false 180 270 195 285
Rectangle -2674135 true true 105 270 150 285
Rectangle -16777216 true false 180 255 210 270
Rectangle -16777216 true false 150 255 165 270
Rectangle -2674135 true true 165 255 180 270
Rectangle -16777216 true false 195 270 210 285
Rectangle -2674135 true true 180 270 195 285
Rectangle -2674135 true true 105 255 135 270
Rectangle -2674135 true true 120 225 135 255
Rectangle -13345367 true false 135 210 150 225
Rectangle -2674135 true true 75 210 90 255
Rectangle -2674135 true true 90 195 135 210
Rectangle -13345367 true false 120 165 180 180
Rectangle -955883 true false 90 150 120 165
Rectangle -13345367 true false 165 240 180 255
Rectangle -13345367 true false 195 240 210 255
Rectangle -13345367 true false 210 195 225 240
Rectangle -13345367 true false 195 180 210 195
Rectangle -13345367 true false 180 165 195 180
Rectangle -13345367 true false 180 240 195 255
Rectangle -13345367 true false 135 225 165 255
Rectangle -13345367 true false 165 225 180 240
Rectangle -13345367 true false 135 180 150 210
Rectangle -13345367 true false 150 180 165 195
Rectangle -13345367 true false 180 210 195 240
Rectangle -11221820 true false 165 180 180 195
Rectangle -13345367 true false 195 225 210 240
Rectangle -13345367 true false 150 195 180 225
Rectangle -13345367 true false 195 195 210 225
Rectangle -1 true false 90 210 120 255
Rectangle -1 true false 120 210 135 225
Rectangle -2674135 true true 90 180 135 195
Rectangle -13345367 true false 105 165 120 180
Rectangle -13345367 true false 75 180 90 210
Rectangle -13345367 true false 90 165 105 180
Rectangle -16777216 true false 75 135 90 165
Rectangle -16777216 true false 60 120 75 150
Rectangle -16777216 true false 45 90 60 135
Rectangle -16777216 true false 60 60 75 90
Rectangle -16777216 true false 75 45 90 60
Rectangle -16777216 true false 90 30 105 45
Rectangle -16777216 true false 105 15 135 30
Rectangle -16777216 true false 135 0 210 15
Rectangle -16777216 true false 210 15 225 45
Rectangle -16777216 true false 120 60 255 75
Rectangle -16777216 true false 150 45 240 60
Rectangle -16777216 true false 180 75 195 105
Rectangle -16777216 true false 150 75 165 105
Rectangle -16777216 true false 90 75 135 90
Rectangle -16777216 true false 105 90 120 135
Rectangle -16777216 true false 120 105 135 120
Rectangle -16777216 true false 150 120 165 135
Rectangle -16777216 true false 135 135 240 150
Rectangle -16777216 true false 165 150 225 165
Rectangle -2674135 true true 135 15 210 45
Rectangle -2674135 true true 105 30 150 60
Rectangle -2674135 true true 90 45 120 75
Rectangle -2674135 true true 75 60 90 75
Rectangle -955883 true false 210 90 240 105
Rectangle -955883 true false 240 105 255 135
Rectangle -955883 true false 165 120 240 135
Rectangle -955883 true false 135 105 240 120
Rectangle -955883 true false 195 90 210 105
Rectangle -955883 true false 165 90 180 105
Rectangle -955883 true false 135 90 150 105
Rectangle -955883 true false 120 120 150 135
Rectangle -955883 true false 120 135 135 150
Rectangle -955883 true false 195 75 210 90
Rectangle -955883 true false 165 75 180 90
Rectangle -955883 true false 135 75 150 90
Rectangle -955883 true false 120 90 135 105
Rectangle -955883 true false 90 135 120 150
Rectangle -955883 true false 120 150 165 165
Rectangle -955883 true false 60 90 75 105
Rectangle -955883 true false 90 90 105 135
Rectangle -6459832 true false 75 90 90 120
Rectangle -955883 true false 60 105 75 120
Rectangle -955883 true false 75 120 90 135
Rectangle -13345367 true false 135 165 150 180
Rectangle -2674135 true true 150 165 180 180
Rectangle -2674135 true true 150 180 195 195
Rectangle -2674135 true true 165 195 195 210
Rectangle -16777216 true false 90 270 105 285
Rectangle -16777216 true false 135 255 150 270
Rectangle -1184463 true false 165 210 180 225
Rectangle -1184463 true false 195 210 210 225
Rectangle -955883 true false 75 75 90 90
Rectangle -16777216 true false 75 75 90 90
Rectangle -16777216 true false 60 180 75 255
Rectangle -16777216 true false 75 165 90 180
Rectangle -16777216 true false 75 255 90 270
Rectangle -16777216 true false 210 240 225 255
Rectangle -16777216 true false 225 195 240 240
Rectangle -16777216 true false 210 180 225 195
Rectangle -16777216 true false 195 165 210 180

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

playground
false
4
Rectangle -1184463 true true 0 285 90 300
Rectangle -1184463 true true 30 270 105 285
Rectangle -1184463 true true 45 255 120 270
Rectangle -1184463 true true 60 240 135 255
Rectangle -1184463 true true 75 225 135 240
Rectangle -1184463 true true 75 210 150 225
Rectangle -1184463 true true 90 195 165 210
Rectangle -1184463 true true 90 180 165 195
Rectangle -1184463 true true 105 165 210 180
Rectangle -1184463 true true 120 150 225 165
Rectangle -7500403 true false 120 120 135 150
Rectangle -7500403 true false 120 105 165 120
Rectangle -7500403 true false 150 120 165 150
Rectangle -7500403 true false 195 105 210 165
Rectangle -7500403 true false 210 105 240 120
Rectangle -7500403 true false 225 120 240 135
Rectangle -7500403 true false 225 135 240 165
Rectangle -7500403 true false 180 180 195 210
Rectangle -7500403 true false 195 210 210 240
Rectangle -7500403 true false 210 240 225 270
Rectangle -7500403 true false 225 270 240 300
Rectangle -7500403 true false 240 165 255 195
Rectangle -7500403 true false 255 195 270 225
Rectangle -7500403 true false 270 225 285 255
Rectangle -7500403 true false 225 240 270 255
Rectangle -7500403 true false 210 210 270 225
Rectangle -7500403 true false 285 255 300 300
Rectangle -7500403 true false 240 270 285 285
Rectangle -7500403 true false 180 180 240 195

police station
false
1
Rectangle -13791810 true false 15 150 120 195
Rectangle -13791810 true false 135 165 285 285
Rectangle -13791810 true false 15 15 225 150
Rectangle -7500403 true false 0 285 315 300
Rectangle -13345367 true false 0 15 15 285
Rectangle -16777216 true false 0 0 270 15
Rectangle -13345367 true false 225 15 240 150
Rectangle -16777216 true false 105 120 150 120
Rectangle -16777216 true false 120 150 420 165
Rectangle -13345367 true false 285 165 300 285
Rectangle -13345367 true false 120 165 135 285
Rectangle -11221820 true false 30 210 105 285
Rectangle -13791810 true false 60 210 75 285
Rectangle -16777216 true false 15 195 120 210
Rectangle -1 true false 15 210 30 285
Rectangle -1 true false 105 210 120 285
Rectangle -7500403 true false 150 195 165 285
Rectangle -7500403 true false 165 195 270 210
Rectangle -7500403 true false 255 210 270 285
Rectangle -16777216 true false 165 210 255 285
Rectangle -11221820 true false 30 150 60 180
Rectangle -11221820 true false 75 150 105 180
Rectangle -11221820 true false 30 30 60 60
Rectangle -11221820 true false 30 90 60 120
Rectangle -11221820 true false 75 90 105 120
Rectangle -11221820 true false 75 30 105 60
Rectangle -11221820 true false 135 30 165 60
Rectangle -11221820 true false 180 30 210 60
Rectangle -11221820 true false 135 90 165 120
Rectangle -11221820 true false 180 90 210 120
Rectangle -13345367 true false 255 15 270 120
Rectangle -16777216 true false 255 120 270 150
Rectangle -13791810 true false 240 15 255 135
Rectangle -16777216 true false 240 135 255 150
Rectangle -16777216 true false 270 135 300 150
Rectangle -16777216 true false 270 120 300 135

school
false
3
Rectangle -7500403 true false 0 285 300 315
Rectangle -6459832 true true 15 60 285 285
Rectangle -7500403 true false 0 45 300 60
Rectangle -7500403 true false 30 30 270 45
Rectangle -7500403 true false 60 15 240 30
Rectangle -7500403 true false 90 0 210 15
Rectangle -11221820 true false 105 210 195 285
Rectangle -7500403 true false 142 210 157 285
Rectangle -7500403 true false 90 195 105 285
Rectangle -7500403 true false 195 195 210 285
Rectangle -7500403 true false 105 195 195 210
Rectangle -7500403 true false 30 195 75 255
Rectangle -7500403 true false 225 195 270 255
Rectangle -7500403 true false 225 90 270 150
Rectangle -7500403 true false 165 90 210 150
Rectangle -7500403 true false 30 90 75 150
Rectangle -7500403 true false 90 90 135 150
Rectangle -11221820 true false 38 203 68 248
Rectangle -11221820 true false 38 97 68 142
Rectangle -11221820 true false 98 98 128 143
Rectangle -11221820 true false 173 97 203 142
Rectangle -11221820 true false 233 97 263 142
Rectangle -11221820 true false 232 203 262 248

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

stash house
false
1
Rectangle -7500403 true false 15 60 255 270
Rectangle -7500403 true false 0 285 300 300
Rectangle -16777216 true false 45 90 210 285
Rectangle -6459832 true false -30 270 255 285
Rectangle -2674135 true true 60 105 195 270
Rectangle -7500403 true false 60 135 195 150
Rectangle -7500403 true false 60 225 195 240
Rectangle -7500403 true false 45 30 285 60
Rectangle -7500403 true false 255 15 300 225
Rectangle -7500403 true false 15 45 45 60
Rectangle -7500403 true false 30 30 60 45
Rectangle -7500403 true false 45 15 75 30
Rectangle -7500403 true false 60 15 255 30
Rectangle -7500403 true false 255 45 270 60
Rectangle -7500403 true false 270 30 285 45
Rectangle -7500403 true false 285 15 300 30
Rectangle -16777216 true false 0 45 15 270
Rectangle -16777216 true false 0 30 30 45
Rectangle -16777216 true false 15 15 45 30
Rectangle -16777216 true false 30 0 300 15
Rectangle -16777216 true false 15 45 255 60
Rectangle -16777216 true false 255 30 270 45
Rectangle -16777216 true false 240 30 255 45
Rectangle -16777216 true false 240 60 255 270
Rectangle -16777216 true false 255 15 300 30
Rectangle -16777216 true false 285 0 300 15
Rectangle -16777216 true false 75 0 90 0
Rectangle -16777216 true false 75 180 105 195
Rectangle -16777216 true false 285 30 300 225
Rectangle -16777216 true false 255 270 270 270
Rectangle -16777216 true false 255 225 270 240
Rectangle -16777216 true false 255 240 270 255
Rectangle -16777216 true false 270 225 285 240
Rectangle -16777216 true false 270 210 285 225

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tile brick
false
0
Rectangle -1 true false 0 0 300 300
Rectangle -7500403 true true 15 225 150 285
Rectangle -7500403 true true 165 225 300 285
Rectangle -7500403 true true 75 150 210 210
Rectangle -7500403 true true 0 150 60 210
Rectangle -7500403 true true 225 150 300 210
Rectangle -7500403 true true 165 75 300 135
Rectangle -7500403 true true 15 75 150 135
Rectangle -7500403 true true 0 0 60 60
Rectangle -7500403 true true 225 0 300 60
Rectangle -7500403 true true 75 0 210 60

tile stones
false
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255

tile water
false
0
Rectangle -7500403 true true -1 0 299 300
Polygon -1 true false 105 259 180 290 212 299 168 271 103 255 32 221 1 216 35 234
Polygon -1 true false 300 161 248 127 195 107 245 141 300 167
Polygon -1 true false 0 157 45 181 79 194 45 166 0 151
Polygon -1 true false 179 42 105 12 60 0 120 30 180 45 254 77 299 93 254 63
Polygon -1 true false 99 91 50 71 0 57 51 81 165 135
Polygon -1 true false 194 224 258 254 295 261 211 221 144 199

toad
false
0
Rectangle -16777216 true false 105 285 210 300
Rectangle -16777216 true false 105 270 120 285
Rectangle -16777216 true false 195 270 195 285
Rectangle -6459832 true false 195 270 210 285
Rectangle -16777216 true false 180 255 195 270
Rectangle -16777216 true false 165 270 180 285
Rectangle -16777216 true false 150 255 165 270
Rectangle -6459832 true false 120 255 135 285
Rectangle -16777216 true false 90 255 105 270
Rectangle -13345367 true false 120 240 135 255
Rectangle -6459832 true false 165 255 180 270
Rectangle -6459832 true false 135 270 165 285
Rectangle -6459832 true false 180 270 195 285
Rectangle -16777216 true false 75 210 90 255
Rectangle -955883 true false 90 210 120 255
Rectangle -955883 true false 120 225 135 240
Rectangle -16777216 true false 90 195 105 210
Rectangle -16777216 true false 105 180 120 195
Rectangle -16777216 true false 105 135 120 180
Rectangle -16777216 true false 90 165 105 180
Rectangle -16777216 true false 75 150 90 165
Rectangle -16777216 true false 60 135 75 150
Rectangle -16777216 true false 45 75 60 135
Rectangle -16777216 true false 60 45 75 75
Rectangle -16777216 true false 75 30 90 45
Rectangle -16777216 true false 90 15 120 30
Rectangle -16777216 true false 120 0 195 15
Rectangle -16777216 true false 195 15 225 30
Rectangle -16777216 true false 225 30 240 45
Rectangle -16777216 true false 240 45 255 60
Rectangle -16777216 true false 255 60 270 120
Rectangle -16777216 true false 240 120 255 135
Rectangle -16777216 true false 225 135 240 150
Rectangle -16777216 true false 210 120 225 150
Rectangle -16777216 true false 135 105 210 120
Rectangle -16777216 true false 120 120 135 135
Rectangle -1 true false 90 120 105 165
Rectangle -1 true false 75 135 90 150
Rectangle -1 true false 105 105 120 135
Rectangle -1 true false 120 90 135 120
Rectangle -1 true false 135 90 225 105
Rectangle -1 true false 210 105 225 120
Rectangle -1 true false 225 120 240 135
Rectangle -2674135 true false 225 75 255 120
Rectangle -2674135 true false 240 60 255 75
Rectangle -2674135 true false 60 75 90 135
Rectangle -2674135 true false 90 75 105 120
Rectangle -2674135 true false 75 60 90 75
Rectangle -2674135 true false 150 30 195 90
Rectangle -2674135 true false 135 45 150 90
Rectangle -2674135 true false 195 45 210 75
Rectangle -1 true false 105 30 120 105
Rectangle -1 true false 105 45 90 75
Rectangle -1 true false 90 30 105 75
Rectangle -1 true false 75 45 90 60
Rectangle -1 true false 120 15 135 30
Rectangle -1 true false 135 90 150 90
Rectangle -2674135 true false 135 15 195 30
Rectangle -2674135 true false 135 30 150 45
Rectangle -1 true false 195 30 225 45
Rectangle -1 true false 210 45 240 75
Rectangle -1 true false 195 75 225 90
Rectangle -16777216 true false 150 120 165 150
Rectangle -16777216 true false 180 120 195 150
Rectangle -955883 true false 135 120 150 165
Rectangle -955883 true false 150 150 165 165
Rectangle -955883 true false 165 120 180 165
Rectangle -955883 true false 195 120 210 165
Rectangle -955883 true false 180 150 195 165
Rectangle -955883 true false 120 135 135 165
Rectangle -955883 true false 135 165 150 180
Rectangle -955883 true false 150 165 180 180
Rectangle -955883 true false 180 165 195 180
Rectangle -955883 true false 195 165 210 180
Rectangle -16777216 true false 150 180 180 195
Rectangle -13345367 true false 105 195 135 210
Rectangle -13345367 true false 135 195 150 255
Rectangle -13345367 true false 120 210 135 225
Rectangle -13345367 true false 180 195 195 255
Rectangle -13345367 true false 195 195 210 255
Rectangle -955883 true false 210 210 225 240
Rectangle -955883 true false 150 210 180 255
Rectangle -955883 true false 150 195 180 210
Rectangle -16777216 true false 120 165 135 195
Rectangle -16777216 true false 195 180 210 195
Rectangle -16777216 true false 210 150 225 180
Rectangle -2674135 true false 120 45 135 75
Rectangle -1 true false 120 75 135 90
Rectangle -1 true false 120 15 135 30
Rectangle -1 true false 135 15 195 30
Rectangle -1 true false 120 30 135 45
Rectangle -16777216 true false 210 195 225 210
Rectangle -16777216 true false 225 210 240 240
Rectangle -16777216 true false 210 240 225 255
Rectangle -16777216 true false 195 255 210 270
Rectangle -16777216 true false 180 180 195 195
Rectangle -16777216 true false 135 180 150 195
Rectangle -1 true false 120 255 210 270
Rectangle -1 true false 135 240 195 255
Rectangle -16777216 true false 210 255 225 285
Rectangle -16777216 true false 105 255 120 270

toad child
true
0
Rectangle -16777216 true false 105 285 210 300
Rectangle -16777216 true false 105 270 120 285
Rectangle -16777216 true false 195 270 195 285
Rectangle -6459832 true false 195 270 210 285
Rectangle -16777216 true false 180 255 195 270
Rectangle -16777216 true false 165 270 180 285
Rectangle -16777216 true false 150 255 165 270
Rectangle -6459832 true false 120 255 135 285
Rectangle -16777216 true false 90 255 105 270
Rectangle -13791810 true false 120 240 135 255
Rectangle -6459832 true false 165 255 180 270
Rectangle -6459832 true false 135 270 165 285
Rectangle -6459832 true false 180 270 195 285
Rectangle -16777216 true false 75 210 90 255
Rectangle -955883 true false 90 210 120 255
Rectangle -955883 true false 120 225 135 240
Rectangle -16777216 true false 90 195 105 210
Rectangle -16777216 true false 105 180 120 195
Rectangle -16777216 true false 105 135 120 180
Rectangle -16777216 true false 90 165 105 180
Rectangle -16777216 true false 75 150 90 165
Rectangle -16777216 true false 60 135 75 150
Rectangle -16777216 true false 45 75 60 135
Rectangle -16777216 true false 60 45 75 75
Rectangle -16777216 true false 75 30 90 45
Rectangle -16777216 true false 90 15 120 30
Rectangle -16777216 true false 120 0 195 15
Rectangle -16777216 true false 195 15 225 30
Rectangle -16777216 true false 225 30 240 45
Rectangle -16777216 true false 240 45 255 60
Rectangle -16777216 true false 255 60 270 120
Rectangle -16777216 true false 240 120 255 135
Rectangle -16777216 true false 225 135 240 150
Rectangle -16777216 true false 210 120 225 150
Rectangle -16777216 true false 135 105 210 120
Rectangle -16777216 true false 120 120 135 135
Rectangle -1 true false 90 120 105 165
Rectangle -1 true false 75 135 90 150
Rectangle -1 true false 105 105 120 135
Rectangle -1 true false 120 90 135 120
Rectangle -1 true false 135 90 225 105
Rectangle -1 true false 210 105 225 120
Rectangle -1 true false 225 120 240 135
Rectangle -13791810 true false 225 75 255 120
Rectangle -13791810 true false 240 60 255 75
Rectangle -13791810 true false 60 75 90 135
Rectangle -13791810 true false 90 75 105 120
Rectangle -13791810 true false 75 60 90 75
Rectangle -13791810 true false 135 30 195 90
Rectangle -13791810 true false 195 45 210 75
Rectangle -1 true false 105 30 120 105
Rectangle -1 true false 105 45 90 75
Rectangle -1 true false 90 30 105 75
Rectangle -1 true false 75 45 90 60
Rectangle -1 true false 120 15 135 30
Rectangle -1 true false 135 90 150 90
Rectangle -2674135 true false 135 15 195 30
Rectangle -1 true false 195 30 225 45
Rectangle -1 true false 210 45 240 75
Rectangle -1 true false 195 75 225 90
Rectangle -16777216 true false 150 120 165 150
Rectangle -16777216 true false 180 120 195 150
Rectangle -955883 true false 135 120 150 165
Rectangle -955883 true false 150 150 165 165
Rectangle -955883 true false 165 120 180 165
Rectangle -955883 true false 195 120 210 165
Rectangle -955883 true false 180 150 195 165
Rectangle -955883 true false 120 135 135 165
Rectangle -955883 true false 135 165 150 180
Rectangle -955883 true false 150 165 180 180
Rectangle -955883 true false 180 165 195 180
Rectangle -955883 true false 195 165 210 180
Rectangle -16777216 true false 150 180 180 195
Rectangle -13791810 true false 105 195 135 210
Rectangle -13791810 true false 135 195 150 240
Rectangle -13791810 true false 120 210 135 225
Rectangle -13791810 true false 180 195 195 240
Rectangle -13791810 true false 195 195 210 255
Rectangle -955883 true false 210 210 225 240
Rectangle -955883 true false 150 210 180 255
Rectangle -955883 true false 150 195 180 210
Rectangle -16777216 true false 120 165 135 195
Rectangle -16777216 true false 195 180 210 195
Rectangle -16777216 true false 210 150 225 180
Rectangle -13791810 true false 120 45 135 75
Rectangle -1 true false 120 75 135 90
Rectangle -1 true false 120 15 135 30
Rectangle -1 true false 135 15 195 30
Rectangle -1 true false 120 30 135 45
Rectangle -16777216 true false 210 195 225 210
Rectangle -16777216 true false 225 210 240 240
Rectangle -16777216 true false 210 240 225 255
Rectangle -16777216 true false 195 255 210 270
Rectangle -16777216 true false 180 180 195 195
Rectangle -16777216 true false 135 180 150 195
Rectangle -1 true false 120 255 210 270
Rectangle -1 true false 135 240 195 255
Rectangle -16777216 true false 210 255 225 285
Rectangle -16777216 true false 105 255 120 270

toad gangster
true
1
Rectangle -16777216 true false 105 285 210 300
Rectangle -16777216 true false 105 270 120 285
Rectangle -16777216 true false 195 270 195 285
Rectangle -6459832 true false 195 270 210 285
Rectangle -16777216 true false 180 255 195 270
Rectangle -16777216 true false 165 270 180 285
Rectangle -16777216 true false 150 255 165 270
Rectangle -6459832 true false 120 255 135 285
Rectangle -16777216 true false 90 255 105 270
Rectangle -2674135 true true 120 240 135 255
Rectangle -6459832 true false 165 255 180 270
Rectangle -6459832 true false 135 270 165 285
Rectangle -6459832 true false 180 270 195 285
Rectangle -16777216 true false 75 210 90 255
Rectangle -955883 true false 90 210 120 255
Rectangle -955883 true false 120 225 135 240
Rectangle -16777216 true false 90 195 105 210
Rectangle -16777216 true false 105 180 120 195
Rectangle -16777216 true false 105 135 120 180
Rectangle -16777216 true false 90 165 105 180
Rectangle -16777216 true false 75 150 90 165
Rectangle -16777216 true false 60 135 75 150
Rectangle -16777216 true false 45 75 60 135
Rectangle -16777216 true false 60 45 75 75
Rectangle -16777216 true false 75 30 90 45
Rectangle -16777216 true false 90 15 120 30
Rectangle -16777216 true false 120 0 195 15
Rectangle -16777216 true false 195 15 225 30
Rectangle -16777216 true false 225 30 240 45
Rectangle -16777216 true false 240 45 255 60
Rectangle -16777216 true false 255 60 270 120
Rectangle -16777216 true false 240 120 255 135
Rectangle -16777216 true false 225 135 240 150
Rectangle -16777216 true false 210 120 225 150
Rectangle -16777216 true false 135 105 210 120
Rectangle -16777216 true false 120 120 135 135
Rectangle -1 true false 90 120 105 165
Rectangle -1 true false 75 135 90 150
Rectangle -1 true false 105 105 120 135
Rectangle -1 true false 120 90 135 120
Rectangle -1 true false 135 90 225 105
Rectangle -1 true false 210 105 225 120
Rectangle -1 true false 225 120 240 135
Rectangle -2674135 true true 225 75 255 120
Rectangle -2674135 true true 240 60 255 75
Rectangle -2674135 true true 60 75 90 135
Rectangle -2674135 true true 90 75 105 120
Rectangle -2674135 true true 75 60 90 75
Rectangle -2674135 true true 135 30 195 90
Rectangle -2674135 true true 195 45 210 75
Rectangle -1 true false 105 30 120 105
Rectangle -1 true false 105 45 90 75
Rectangle -1 true false 90 30 105 75
Rectangle -1 true false 75 45 90 60
Rectangle -1 true false 120 15 135 30
Rectangle -1 true false 135 90 150 90
Rectangle -2674135 true true 135 15 195 30
Rectangle -1 true false 195 30 225 45
Rectangle -1 true false 210 45 240 75
Rectangle -1 true false 195 75 225 90
Rectangle -16777216 true false 150 120 165 150
Rectangle -16777216 true false 180 120 195 150
Rectangle -955883 true false 135 120 150 165
Rectangle -955883 true false 150 150 165 165
Rectangle -955883 true false 165 120 180 165
Rectangle -955883 true false 195 120 210 165
Rectangle -955883 true false 180 150 195 165
Rectangle -955883 true false 120 135 135 165
Rectangle -955883 true false 135 165 150 180
Rectangle -955883 true false 150 165 180 180
Rectangle -955883 true false 180 165 195 180
Rectangle -955883 true false 195 165 210 180
Rectangle -16777216 true false 150 195 180 210
Rectangle -2674135 true true 105 195 135 210
Rectangle -2674135 true true 135 195 150 240
Rectangle -2674135 true true 120 210 135 225
Rectangle -2674135 true true 180 195 195 240
Rectangle -2674135 true true 195 195 210 255
Rectangle -955883 true false 210 210 225 240
Rectangle -955883 true false 150 210 180 255
Rectangle -955883 true false 150 210 180 225
Rectangle -16777216 true false 120 165 135 195
Rectangle -16777216 true false 195 180 210 195
Rectangle -16777216 true false 210 150 225 180
Rectangle -2674135 true true 120 45 135 75
Rectangle -1 true false 120 75 135 90
Rectangle -1 true false 120 15 135 30
Rectangle -1 true false 135 15 195 30
Rectangle -1 true false 120 30 135 45
Rectangle -16777216 true false 210 195 225 210
Rectangle -16777216 true false 225 210 240 240
Rectangle -16777216 true false 210 240 225 255
Rectangle -16777216 true false 195 255 210 270
Rectangle -955883 true false 150 180 195 195
Rectangle -16777216 true false 135 180 150 195
Rectangle -1 true false 120 255 210 270
Rectangle -1 true false 135 240 195 255
Rectangle -16777216 true false 210 255 225 285
Rectangle -16777216 true false 105 255 120 270
Rectangle -16777216 true false 150 165 165 180
Rectangle -16777216 true false 165 165 180 180
Rectangle -16777216 true false 180 165 195 180

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

waluigi
true
0
Rectangle -16777216 true false 150 285 225 300
Rectangle -16777216 true false 60 285 135 300
Rectangle -6459832 true false 75 270 120 285
Rectangle -6459832 true false 165 270 210 285
Rectangle -16777216 true false 90 225 135 255
Rectangle -16777216 true false 150 225 195 255
Rectangle -16777216 true false 105 195 180 225
Rectangle -955883 true false 90 210 105 225
Rectangle -955883 true false 60 210 90 255
Rectangle -955883 true false 180 210 195 225
Rectangle -955883 true false 195 210 225 255
Rectangle -8630108 true false 60 180 105 210
Rectangle -8630108 true false 180 180 225 210
Rectangle -16777216 true false 165 195 165 195
Rectangle -16777216 true false 135 165 150 195
Rectangle -16777216 true false 150 135 165 180
Rectangle -16777216 true false 120 135 135 180
Rectangle -1184463 true false 120 180 135 195
Rectangle -1184463 true false 150 180 150 195
Rectangle -1184463 true false 150 180 165 195
Rectangle -16777216 true false 165 180 180 195
Rectangle -16777216 true false 105 180 120 195
Rectangle -8630108 true false 90 150 120 180
Rectangle -8630108 true false 165 150 210 180
Rectangle -8630108 true false 90 135 120 150
Rectangle -8630108 true false 165 135 195 150
Rectangle -8630108 true false 135 135 150 165
Rectangle -955883 true false 90 120 195 135
Rectangle -955883 true false 90 105 150 120
Rectangle -16777216 true false 150 105 210 120
Rectangle -5825686 true false 180 90 225 105
Rectangle -5825686 true false 165 75 210 90
Rectangle -8630108 true false 60 45 210 60
Rectangle -8630108 true false 90 30 180 45
Rectangle -8630108 true false 120 15 180 30
Rectangle -8630108 true false 150 0 180 15
Rectangle -6459832 true false 150 60 165 90
Rectangle -955883 true false 165 60 180 75
Rectangle -955883 true false 150 90 180 105
Rectangle -16777216 true false 135 90 150 105
Rectangle -16777216 true false 120 75 135 90
Rectangle -955883 true false 135 60 150 90
Rectangle -955883 true false 120 60 150 75
Rectangle -955883 true false 105 75 120 90
Rectangle -955883 true false 120 90 135 105
Rectangle -6459832 true false 90 90 120 105
Rectangle -6459832 true false 90 75 105 90
Rectangle -6459832 true false 75 60 120 75
Rectangle -6459832 true false 60 75 75 120
Rectangle -8630108 true false 75 150 90 180
Rectangle -8630108 true false 195 165 210 180
Rectangle -955883 true false 75 75 90 105
Rectangle -1 true false 165 15 180 45
Rectangle -6459832 true false 75 105 90 120
Rectangle -16777216 true false 135 15 150 15
Rectangle -16777216 true false 135 15 150 15
Rectangle -16777216 true false 120 0 150 15
Rectangle -16777216 true false 90 15 120 30
Rectangle -16777216 true false 60 30 90 45
Rectangle -16777216 true false 45 45 60 60
Rectangle -16777216 true false 60 60 75 75
Rectangle -16777216 true false 45 75 60 120
Rectangle -16777216 true false 60 120 90 135
Rectangle -16777216 true false 75 135 90 150
Rectangle -16777216 true false 60 150 75 180
Rectangle -16777216 true false 45 180 60 255
Rectangle -16777216 true false 60 255 90 270
Rectangle -16777216 true false 180 0 195 45
Rectangle -16777216 true false 195 30 210 45
Rectangle -16777216 true false 210 45 225 60
Rectangle -16777216 true false 180 60 210 75
Rectangle -16777216 true false 210 75 225 90
Rectangle -16777216 true false 195 255 225 270
Rectangle -16777216 true false 225 180 240 255
Rectangle -16777216 true false 210 150 225 180
Rectangle -16777216 true false 195 135 210 150
Rectangle -16777216 true false 150 255 165 285
Rectangle -16777216 true false 120 255 135 285
Rectangle -16777216 true false 60 270 75 285
Rectangle -16777216 true false 210 270 225 285
Rectangle -6459832 true false 165 255 195 270
Rectangle -6459832 true false 90 255 120 270
Rectangle -16777216 true false 195 120 210 135
Rectangle -16777216 true false 210 105 225 120
Rectangle -16777216 true false 225 90 240 105

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

workplace
false
14
Rectangle -13345367 true false 0 285 300 300
Rectangle -7500403 true false 15 0 285 285
Rectangle -7500403 true false 0 255 15 270
Rectangle -7500403 true false 0 180 15 195
Rectangle -7500403 true false 0 105 15 120
Rectangle -7500403 true false 0 30 15 45
Rectangle -7500403 true false 285 30 300 45
Rectangle -7500403 true false 285 105 300 120
Rectangle -7500403 true false 285 255 300 270
Rectangle -7500403 true false 285 180 300 195
Rectangle -13345367 true false 0 240 15 255
Rectangle -13345367 true false 0 165 15 180
Rectangle -13345367 true false 0 90 15 105
Rectangle -13345367 true false 0 15 15 30
Rectangle -13345367 true false 285 15 300 30
Rectangle -13345367 true false 285 90 300 105
Rectangle -13345367 true false 285 165 300 180
Rectangle -13345367 true false 285 240 300 255
Rectangle -6459832 true false 105 225 195 285
Rectangle -13791810 true false 45 225 75 255
Rectangle -13791810 true false 45 165 75 195
Rectangle -13791810 true false 45 105 75 135
Rectangle -13791810 true false 45 45 75 75
Rectangle -1 true false 30 15 45 285
Rectangle -1 true false 45 15 270 30
Rectangle -1 true false 255 30 270 285
Rectangle -13791810 true false 225 225 255 255
Rectangle -13791810 true false 225 165 255 195
Rectangle -13791810 true false 225 105 255 135
Rectangle -13791810 true false 225 45 255 75
Rectangle -13791810 true false 105 45 135 75
Rectangle -13791810 true false 165 45 195 75
Rectangle -13791810 true false 165 165 195 195
Rectangle -13791810 true false 105 165 135 195
Rectangle -13791810 true false 105 105 135 135
Rectangle -13791810 true false 165 105 195 135
Rectangle -13345367 true false 60 60 75 75
Rectangle -13345367 true false 45 45 60 60
Rectangle -13345367 true false 105 45 120 60
Rectangle -13345367 true false 120 60 135 75
Rectangle -13345367 true false 165 45 180 60
Rectangle -13345367 true false 180 60 195 75
Rectangle -13345367 true false 225 45 240 60
Rectangle -13345367 true false 240 60 255 75
Rectangle -13345367 true false 225 105 240 120
Rectangle -13345367 true false 240 120 255 135
Rectangle -13345367 true false 165 105 180 120
Rectangle -13345367 true false 180 120 195 135
Rectangle -13345367 true false 105 105 120 120
Rectangle -13345367 true false 120 120 135 135
Rectangle -13345367 true false 45 105 60 120
Rectangle -13345367 true false 60 120 75 135
Rectangle -13345367 true false 45 165 60 180
Rectangle -13345367 true false 60 180 75 195
Rectangle -13345367 true false 105 165 120 180
Rectangle -13345367 true false 120 180 135 195
Rectangle -13345367 true false 165 165 180 180
Rectangle -13345367 true false 180 180 195 195
Rectangle -13345367 true false 225 165 240 180
Rectangle -13345367 true false 240 180 255 195
Rectangle -13345367 true false 225 225 240 240
Rectangle -13345367 true false 240 240 255 255
Rectangle -13345367 true false 45 225 60 240
Rectangle -13345367 true false 60 240 75 255
Rectangle -7500403 true false 141 225 156 285

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
