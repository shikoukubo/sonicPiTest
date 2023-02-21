set_volume! 2

use_bpm 180
i=0 #アウフタクト制御用、1番二番を意識する必要ありそう
#############################################
##| drums
#############################################
define :bdPerLength do |per|
  sample :bd_fat
  sleep 1.0/per
end

define :sdPerLength do |per|
  sample :sn_dolf
  sleep 1.0/per
end
#------------------------------
# todo 2番のパターン追加
live_loop :drums do
  ##| stop
  sleep 2 if i==0
  
  6.times do
    bdPerLength 1
    sdPerLength 1
    bdPerLength 2
    bdPerLength 2
    sdPerLength 1
  end
  if i==0
    4.times do
      bdPerLength 2
      sdPerLength 4
      sdPerLength 4
      sdPerLength 4
      sdPerLength 4
    end
    2.times do
      sdPerLength 4
      sdPerLength 4
      sdPerLength 4
      sdPerLength 4
    end
  end
  
  ##| 制御用
  i=+1
  if i==2
    stop
  end
end
#############################################
##| hihat
#############################################
live_loop :hihat do
  ##| stop
  sample :drum_cymbal_open, amp: 0.2
  sample :drum_splash_hard, amp: 0.1
  sleep 1
end

#############################################
##| bass
#############################################
bassLine = [:Ab0 ,:A1, :B1, :Db2, :D2, :E2, :Gb2, :Ab2, :A2 , :F2]
define :bassOneBars8times do |ln|
  8.times do
    play bassLine.ring[ln], amp: 0.6
    sleep 0.5
  end
end

define :bassAnyTimes do |ln, n|
  n.times do
    play bassLine.ring[ln], amp: 0.6
    sleep 0.5
  end
end
#------------------------------
use_synth :bass_foundation
live_loop :bsSabi do
  ##| stop
  sleep 2 if i==0
  
  bassOneBars8times 4
  bassOneBars8times 5
  bassOneBars8times 6
  bassOneBars8times 8
  
  bassOneBars8times 4
  bassOneBars8times 3
  bassAnyTimes 6, 3
  bassAnyTimes 5, 3
  bassAnyTimes 2, 3
  bassAnyTimes 4, 3
  bassAnyTimes 3, 4
  
  bassOneBars8times 4
  bassOneBars8times 5
  bassAnyTimes 3, 3
  bassAnyTimes 9, 5
  bassAnyTimes 6, 4
  bassAnyTimes 5, 4
  
  bassOneBars8times 4
  bassOneBars8times 5
  bassOneBars8times 6
  bassOneBars8times 8
  
  bassOneBars8times 4
  bassAnyTimes 5, 2
  sleep 1
  play :E2, release: 2
  sleep 2
  
  ##| 制御用
  i=+1
end

#############################################
##| guitar
#############################################
guitarDiatonic = [:Ab2 ,:A2, :B2, :Db3, :D3, :E3, :Gb3, :Ab3, :A3 , :Db3]
chordFunction = [:major, :minor, :major, :dim]
sleepTimes1 = [1, 0.5, 1, 0.5, 0.5, 0.25, 0.25]

define :gtOneBars do |n|
  chordFunc = chordFunction[0] if n==1 or n==4 or n==8
  chordFunc = chordFunction[1] if n==2 or n==3 or n==6
  chordFunc = chordFunction[2] if n==5 or n==9
  chordFunc = chordFunction[3] if n==7 or n==0
  7.times do
    play chord(guitarDiatonic.ring[n], chordFunc)
    sleep sleepTimes1.ring.tick
  end
end

define :gtAnyTime do |n, l|
  chordFunc = chordFunction[0] if n==1 or n==4 or n==8
  chordFunc = chordFunction[1] if n==2 or n==3 or n==6
  chordFunc = chordFunction[2] if n==5 or n==9
  chordFunc = chordFunction[3] if n==7 or n==0
  
  l.times do
    puts(chordFunc)
    play chord(guitarDiatonic.ring[n], chordFunc)
    sleep 1.0/2
  end
end
#------------------------------
use_synth :saw
live_loop :gtSabi do
  ##| stop
  sleep 2 if i==0
  
  gtOneBars 4
  gtOneBars 5
  gtOneBars 6
  gtOneBars 8
  
  gtOneBars 4
  gtOneBars 9
  gtOneBars 6
  gtOneBars 8
  
  gtOneBars 4
  gtOneBars 5
  gtAnyTime 9, 3
  gtAnyTime 7, 5
  gtAnyTime 6, 4
  gtAnyTime 5, 4
  
  gtOneBars 4
  gtOneBars 5
  gtOneBars 6
  gtOneBars 8
  
  gtOneBars 4
  gtAnyTime 5, 2
  sleep 1
  gtAnyTime 5, 2
  sleep 1
  
end

#############################################
##| melody
#############################################
melodyDiatonic = [:Ab3 ,:A3, :B3, :Db4, :D4, :E4, :Gb4, :Ab4,
                  :A4, :B4, :Db5, :D5, :F4]
define :singMelody do |n, len|
  play melodyDiatonic[n]
  sleep 1.0/len
end
##| 共通メロを別だし
define :singMelodyCommon do
  singMelody 5, 2
  singMelody 6, 2
  singMelody 6, 1
  singMelody 5, 2
  singMelody 6, 2
  singMelody 6, 1
  
  singMelody 7, 1
  singMelody 8, 1
  singMelody 9, 1
  singMelody 7, 1
end
#----------------------------
l=0 #アウフタクト制御用
use_synth :square
live_loop :vocal do
  ##| stop
  
  if l==0 then
    singMelody 6, 1
    singMelody 5, 1
  end
  
  if l==0 or 1 then
    singMelodyCommon
  end
  
  ##| 1番
  if l==0 then
    singMelody 7, 1
    singMelody 8, 1
    singMelody 7, 1
    singMelody 5, 1
    
    singMelody 3, 2
    sleep 1
    singMelody 3, 2
    singMelody 6, 2
    singMelody 5, 2
    singMelody 3, 2
    singMelody 1, 2
    
    singMelody 2, 2
    singMelody 3, 2
    sleep 0.5
    singMelody 1, 2
    singMelody 2, 2
    singMelody 3, 2
    sleep 0.5
    singMelody 1, 2
    
    singMelody 2, 1
    singMelody 3, 1
    singMelody 5, 1
    singMelody 3, 1
    
    singMelody 2, 1
    singMelody 3, 1
    singMelody 2, 1
    singMelody 1, 1
    
    singMelody 3, 0.5
    singMelody 6, 1
    singMelody 5, 1
  end
  
  ##| 2番
  if l==1 then
    singMelody 12, 0.5
    singMelody 11, 0.5
    
    singMelody 10, 0.5
    singMelody 8, 1
    singMelody 9, 1
    
    singMelody 10, 1
    singMelody 11, 2
    singMelody 9, 1
    sleep 0.5
    singMelody 8, 1
    
    singMelody 7, 1
    singMelody 6, 1
    singMelody 7, 1
    singMelody 8, 1
    
    sleep 4
    
    sleep 2
    singMelody 8, 1
    singMelody 9, 1
    
    singMelody 10, 1
    singMelody 11, 2
    singMelody 9, 1
    sleep 0.5
    singMelody 8, 1
    
    singMelody 7, 1
    singMelody 6, 1
    singMelody 7, 1
    singMelody 8, 0.25
  end
  
  #制御用
  l=+1
end
