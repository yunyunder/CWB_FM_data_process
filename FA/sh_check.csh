#!/bin/csh


foreach event(`ls -df 20*`)
    echo $event
    ls $event/*BHZ.SAC | wc -l

end

